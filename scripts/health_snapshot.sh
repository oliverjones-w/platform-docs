#!/usr/bin/env bash
# health_snapshot.sh — bankst-os stack health check
#
# Run from Dell (platform-docs root):
#   bash scripts/health_snapshot.sh           # terminal output only
#   bash scripts/health_snapshot.sh --write   # also writes LAST_SNAPSHOT.md
#
# Requires: SSH access to Mac via 'macdev' alias (~/.ssh/config on Dell)

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SNAPSHOT_FILE="$REPO_ROOT/LAST_SNAPSHOT.md"

MAC_SSH="macdev"  # alias in ~/.ssh/config -> dev-server@100.82.94.80
MAC_NODE_BIN="/Users/dev-server/.nvm/versions/node/v24.14.0/bin"
MAC_PM2="${MAC_NODE_BIN}/pm2"
STALE_SECS=5400  # 90 min (hourly sync + 30 min grace)

WRITE=0
[[ "${1:-}" == "--write" ]] && WRITE=1

# ── Terminal colors ───────────────────────────────────────────────────────────
R='\033[0;31m' G='\033[0;32m' Y='\033[1;33m' B='\033[1m' N='\033[0m'

hdr()  { printf "\n${B}%s${N}\n" "$*"; }
ok()   { printf "  ${G}ok${N}    %s\n" "$*"; }
warn() { printf "  ${Y}warn${N}  %s\n" "$*"; }
fail() { printf "  ${R}FAIL${N}  %s\n" "$*"; }

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

fmt_age() {
  local s=$1
  if   (( s < 60 ));   then echo "${s}s";
  elif (( s < 3600 )); then echo "$(( s/60 ))m";
  else                      echo "$(( s/3600 ))h $(( (s%3600)/60 ))m"; fi
}

# ── Collect Mac data in one SSH round-trip ────────────────────────────────────
hdr "Mac runtime (macdev / 100.82.94.80)"

MAC_RAW=$(ssh -o ConnectTimeout=10 -o BatchMode=yes "$MAC_SSH" bash << 'REMOTE'
export PATH="/Users/dev-server/.nvm/versions/node/v24.14.0/bin:$PATH"

echo '===PM2==='
pm2 jlist 2>/dev/null | python3 -c "
import sys, json
try:
    procs = json.load(sys.stdin)
    for p in procs:
        name     = p.get('name','?')
        status   = p.get('pm2_env',{}).get('status','?')
        pid      = p.get('pid','?')
        mem      = p.get('monit',{}).get('memory',0)
        mem_mb   = round(mem/1024/1024,1) if mem else 0
        restarts = p.get('pm2_env',{}).get('restart_time',0)
        print(f'{name}|{status}|{pid}|{mem_mb}MB|{restarts}')
except Exception as e:
    print(f'PM2_ERROR:{e}')
" || echo 'PM2_UNAVAILABLE'

echo '===DBAGES==='
NOW=$(/bin/date +%s)
for entry in \
  "hf_map:/Users/dev-server/workspace/services/mapping_tools/hf_map.db" \
  "ir_map:/Users/dev-server/workspace/services/mapping_tools/ir_map.db" \
  "bbg_results:/Users/dev-server/workspace/services/mapping_tools/bbg_results.db" \
  "candidate_sync:/Users/dev-server/workspace/services/encore_scraper/sync_state/candidate_sync.db"
do
  name="${entry%%:*}"
  path="${entry#*:}"
  if [ -f "$path" ]; then
    mtime=$(/usr/bin/stat -f "%m" "$path")
    echo "$name $(( NOW - mtime ))"
  else
    echo "$name MISSING"
  fi
done

echo '===PORTS==='
for port in 7842 3000 8765 8001 8003 5050; do
  /usr/bin/nc -z -w2 127.0.0.1 $port 2>/dev/null && echo "$port open" || echo "$port closed"
done
REMOTE
) 2>&1 || { fail "SSH connection to Mac failed"; exit 1; }

# ── Parse sections ────────────────────────────────────────────────────────────
PM2_RAW=$(echo  "$MAC_RAW" | awk '/^===PM2===$/    {f=1;next} /^===DBAGES===$/  {f=0} f{print}')
DB_RAW=$(echo   "$MAC_RAW" | awk '/^===DBAGES===$/  {f=1;next} /^===PORTS===$/   {f=0} f{print}')
PORT_RAW=$(echo "$MAC_RAW" | awk '/^===PORTS===$/   {f=1;next}                   f{print}')

# ── PM2 services ─────────────────────────────────────────────────────────────
hdr "  Services (PM2)"
declare -A SVC_PORT=( [gateway]=7842 [frontend]=3000 [core]=8765 [finra]=8001 [mapping]=8003 [encore]=5050 )

if echo "$PM2_RAW" | grep -qE "PM2_UNAVAILABLE|PM2_ERROR"; then
  fail "pm2 unavailable: $(echo "$PM2_RAW" | grep -E 'PM2_')"
else
  printf "  %-16s %-10s %-8s %-10s %s\n" "NAME" "STATUS" "PID" "MEMORY" "RESTARTS"
  while IFS='|' read -r name status pid mem restarts; do
    if [[ "$status" == "online" ]]; then
      printf "  ${G}%-16s${N} %-10s %-8s %-10s %s\n" "$name" "$status" "$pid" "$mem" "$restarts"
    else
      printf "  ${R}%-16s${N} %-10s %-8s %-10s %s\n" "$name" "$status" "$pid" "$mem" "$restarts"
    fi
  done <<< "$PM2_RAW"
fi

# ── Port checks ───────────────────────────────────────────────────────────────
hdr "  Port checks"
declare -A PORT_NAME=( [7842]="gateway" [3000]="frontend" [8765]="core" [8001]="finra" [8003]="mapping" [5050]="encore" )
while read -r port status; do
  name="${PORT_NAME[$port]:-unknown}"
  if [[ "$status" == "open" ]]; then
    ok ":$port  $name"
  else
    fail ":$port  $name — not listening"
  fi
done <<< "$PORT_RAW"

# ── DB freshness ──────────────────────────────────────────────────────────────
hdr "  Mapping DB freshness  (stale > 90 min)"
DB_STATUS=()
while read -r name age_raw; do
  if [[ "$age_raw" == "MISSING" ]]; then
    fail "$name — not found on Mac"
    DB_STATUS+=("$name:MISSING")
  elif (( age_raw > STALE_SECS )); then
    warn "$name — $(fmt_age "$age_raw") old  [STALE]"
    DB_STATUS+=("$name:STALE:$age_raw")
  else
    ok "$name — $(fmt_age "$age_raw") old"
    DB_STATUS+=("$name:ok:$age_raw")
  fi
done <<< "$DB_RAW"

# ── Dell checks ───────────────────────────────────────────────────────────────
hdr "Dell ingestion (local)"

SYNC_LOG="/c/dev/tools/mapping_tools/logs/sync.log"
if [[ -f "$SYNC_LOG" ]]; then
  LAST_DONE=$(grep "=== Done ===" "$SYNC_LOG" | tail -1)
  LAST_ERR=$(grep "ERROR" "$SYNC_LOG" | tail -1)

  if [[ -n "$LAST_DONE" ]]; then
    DONE_TS=$(echo "$LAST_DONE" | grep -oP '\[\K[^\]]+')
    ok "Last sync completed: $DONE_TS"
  fi

  if [[ -n "$LAST_ERR" ]]; then
    ERR_TS=$(echo "$LAST_ERR" | grep -oP '\[\K[^\]]+' | head -1)
    ERR_MSG=$(echo "$LAST_ERR" | sed 's/\[[^]]*\] //')
    warn "Last error: $ERR_TS — $ERR_MSG"
  fi
else
  warn "sync.log not found at $SYNC_LOG"
fi

# Task Scheduler
TS_OUT=$(powershell.exe -NoProfile -Command "
\$t = Get-ScheduledTaskInfo -TaskName MappingToolsSync -ErrorAction SilentlyContinue
if (\$t) {
  \$lr = \$t.LastRunTime.ToString('yyyy-MM-dd HH:mm:ss')
  \$nr = \$t.NextRunTime.ToString('yyyy-MM-dd HH:mm:ss')
  \$rc = \$t.LastTaskResult
  Write-Output \"LAST_RUN:\$lr\"
  Write-Output \"NEXT_RUN:\$nr\"
  Write-Output \"LAST_RESULT:\$rc\"
} else { Write-Output 'NOT_FOUND' }
" 2>/dev/null | tr -d '\r')

if echo "$TS_OUT" | grep -q "NOT_FOUND"; then
  warn "MappingToolsSync scheduled task not found"
else
  LR=$(echo "$TS_OUT" | grep LAST_RUN    | cut -d: -f2-)
  NR=$(echo "$TS_OUT" | grep NEXT_RUN    | cut -d: -f2-)
  RC=$(echo "$TS_OUT" | grep LAST_RESULT | cut -d: -f2-)
  if [[ "$RC" == "0" ]]; then
    ok "MappingToolsSync last run: $LR (success)"
  else
    fail "MappingToolsSync last run: $LR (exit code $RC)"
  fi
  ok "Next scheduled run: $NR"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "Snapshot: $TIMESTAMP"
echo ""

# ── Write LAST_SNAPSHOT.md ────────────────────────────────────────────────────
if [[ $WRITE -eq 1 ]]; then
  {
    echo "# Last Health Snapshot"
    echo ""
    echo "Generated: $TIMESTAMP  "
    echo "Run \`bash scripts/health_snapshot.sh --write\` to refresh."
    echo ""
    echo "## Mac Services (PM2)"
    echo ""
    if echo "$PM2_RAW" | grep -qE "PM2_UNAVAILABLE|PM2_ERROR"; then
      echo "- PM2 unavailable"
    else
      echo "| Name | Status | PID | Memory | Restarts |"
      echo "|---|---|---|---|---|"
      while IFS='|' read -r name status pid mem restarts; do
        flag=""; [[ "$status" != "online" ]] && flag=" **WARN**"
        echo "| $name | $status$flag | $pid | $mem | $restarts |"
      done <<< "$PM2_RAW"
    fi
    echo ""
    echo "## Mapping DB Freshness"
    echo ""
    echo "| DB | Age | Status |"
    echo "|---|---|---|"
    while read -r name age_raw; do
      if [[ "$age_raw" == "MISSING" ]]; then
        echo "| $name | — | MISSING |"
      elif (( age_raw > STALE_SECS )); then
        echo "| $name | $(fmt_age "$age_raw") | STALE |"
      else
        echo "| $name | $(fmt_age "$age_raw") | ok |"
      fi
    done <<< "$DB_RAW"
    echo ""
    echo "## Dell Sync"
    echo ""
    if [[ -n "${LAST_DONE:-}" ]]; then
      echo "- Last completed: $DONE_TS"
    fi
    if [[ -n "${LAST_ERR:-}" ]]; then
      echo "- Last error: $ERR_TS — $ERR_MSG"
    fi
    if ! echo "$TS_OUT" | grep -q "NOT_FOUND" && [[ -n "${LR:-}" ]]; then
      echo "- MappingToolsSync last run: $LR (exit $RC)"
      echo "- Next run: $NR"
    fi
  } > "$SNAPSHOT_FILE"
  echo "Written: $SNAPSHOT_FILE"
fi
