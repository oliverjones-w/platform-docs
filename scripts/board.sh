#!/usr/bin/env bash
# board.sh — agent interface to the bankst-os GitHub Projects board
#
# Durable object is a real GitHub Issue in oliverjones-w/platform-docs.
# The Project V2 board is the visibility layer on top.
#
# Usage:
#   board.sh add "Task title"             create issue, add to board as Todo
#   board.sh start <issue-number>         In Progress + label agent-active
#   board.sh done <issue-number> ["msg"]  Done + close issue + optional comment
#   board.sh todo <issue-number>          reopen + move back to Todo
#   board.sh list                         print board state with issue numbers
#
# All project IDs are hardcoded — no discovery step needed.

set -euo pipefail

OWNER="oliverjones-w"
REPO="platform-docs"
PROJECT_ID="PVT_kwHOCNteG84BV0f8"
FIELD_ID="PVTSSF_lAHOCNteG84BV0f8zhRNeZU"
OPT_TODO="f75ad846"
OPT_IN_PROGRESS="47fc9ee4"
OPT_DONE="98236657"

# ---------------------------------------------------------------------------

die() { echo "error: $*" >&2; exit 1; }

# Given an issue number, return its project item ID in PROJECT_ID.
get_item_id() {
    local number="$1"
    gh api graphql -f query="
    query {
      repository(owner: \"$OWNER\", name: \"$REPO\") {
        issue(number: $number) {
          projectItems(first: 10) {
            nodes { id project { id } }
          }
        }
      }
    }" | python3 -c "
import json, sys
project_id = sys.argv[1]
data = json.load(sys.stdin)
nodes = data['data']['repository']['issue']['projectItems']['nodes']
for n in nodes:
    if n['project']['id'] == project_id:
        print(n['id']); sys.exit(0)
die('issue not found in project')
" "$PROJECT_ID"
}

set_status() {
    local item_id="$1"
    local option_id="$2"
    gh api graphql -f query="mutation {
        updateProjectV2ItemFieldValue(input: {
            projectId: \"$PROJECT_ID\"
            itemId: \"$item_id\"
            fieldId: \"$FIELD_ID\"
            value: { singleSelectOptionId: \"$option_id\" }
        }) { projectV2Item { id } }
    }" > /dev/null
}

# ---------------------------------------------------------------------------

cmd="${1:-}"
arg="${2:-}"
msg="${3:-}"

case "$cmd" in
    add)
        [[ -n "$arg" ]] || die "usage: board.sh add \"Task title\""

        # Create real issue in platform-docs
        issue_url=$(gh issue create \
            --repo "$OWNER/$REPO" \
            --title "$arg" \
            --label "agent-task" \
            --body "")
        issue_num=$(basename "$issue_url")

        # Get issue node ID and add to project
        node_id=$(gh api "repos/$OWNER/$REPO/issues/$issue_num" --jq '.node_id')
        item_id=$(gh api graphql -f query="mutation {
            addProjectV2ItemById(input: {
                projectId: \"$PROJECT_ID\"
                contentId: \"$node_id\"
            }) { item { id } }
        }" --jq '.data.addProjectV2ItemById.item.id')

        set_status "$item_id" "$OPT_TODO"
        echo "added: #$issue_num — $arg"
        ;;

    start)
        [[ -n "$arg" ]] || die "usage: board.sh start <issue-number>"
        item_id=$(get_item_id "$arg")
        set_status "$item_id" "$OPT_IN_PROGRESS"
        gh issue edit "$arg" --repo "$OWNER/$REPO" --add-label "agent-active" 2>/dev/null || true
        [[ -n "$msg" ]] && gh issue comment "$arg" --repo "$OWNER/$REPO" --body "$msg" > /dev/null
        echo "in progress: #$arg"
        ;;

    done)
        [[ -n "$arg" ]] || die "usage: board.sh done <issue-number> [\"summary\"]"
        item_id=$(get_item_id "$arg")
        set_status "$item_id" "$OPT_DONE"
        [[ -n "$msg" ]] && gh issue comment "$arg" --repo "$OWNER/$REPO" --body "$msg" > /dev/null
        gh issue close "$arg" --repo "$OWNER/$REPO" 2>/dev/null || true
        echo "done: #$arg"
        ;;

    todo)
        [[ -n "$arg" ]] || die "usage: board.sh todo <issue-number>"
        item_id=$(get_item_id "$arg")
        set_status "$item_id" "$OPT_TODO"
        gh issue reopen "$arg" --repo "$OWNER/$REPO" 2>/dev/null || true
        echo "todo: #$arg"
        ;;

    list)
        gh api graphql -f query="
        query {
          node(id: \"$PROJECT_ID\") {
            ... on ProjectV2 {
              items(first: 100) {
                nodes {
                  id
                  status: fieldValueByName(name: \"Status\") {
                    ... on ProjectV2ItemFieldSingleSelectValue { name }
                  }
                  content {
                    ... on Issue      { number title }
                    ... on DraftIssue { title }
                  }
                }
              }
            }
          }
        }" | python3 -c "
import json, sys
data = json.load(sys.stdin)
nodes = data['data']['node']['items']['nodes']
for n in nodes:
    status  = (n.get('status') or {}).get('name', '?')
    content = n.get('content') or {}
    number  = content.get('number')
    title   = content.get('title', '(no title)')
    num_str = f'#{number}' if number else '    '
    print(f'{status:15} {num_str:6} | {title}')
"
        ;;

    *)
        echo "usage: board.sh <add|start|done|todo|list> [args]" >&2
        exit 1
        ;;
esac
