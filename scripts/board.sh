#!/usr/bin/env bash
# board.sh — lightweight wrapper for the bankst-os GitHub Projects board
#
# Usage:
#   board.sh add "Task title"           add new item (Todo)
#   board.sh start "Task title"         move item to In Progress (by title match)
#   board.sh done "Task title"          move item to Done (by title match)
#   board.sh todo "Task title"          move item back to Todo (by title match)
#   board.sh list                       print all items with current status
#
# All IDs are hardcoded — no discovery step needed.

set -euo pipefail

OWNER="oliverjones-w"
PROJECT_NUMBER="2"
PROJECT_ID="PVT_kwHOCNteG84BV0f8"
FIELD_ID="PVTSSF_lAHOCNteG84BV0f8zhRNeZU"
OPT_TODO="f75ad846"
OPT_IN_PROGRESS="47fc9ee4"
OPT_DONE="98236657"

# ---------------------------------------------------------------------------

die() { echo "error: $*" >&2; exit 1; }

require_title() {
    [[ -n "${1:-}" ]] || die "title argument required"
}

# Find item ID by exact or case-insensitive substring match against title.
# Prints the item ID, or empty string if not found.
find_item_id() {
    local title="$1"
    gh project item-list "$PROJECT_NUMBER" \
        --owner "$OWNER" \
        --format json \
        -L 100 \
    | python3 -c "
import json, sys
needle = sys.argv[1].lower()
data = json.load(sys.stdin)
for item in data.get('items', []):
    if item.get('title', '').lower() == needle:
        print(item['id'])
        sys.exit(0)
# fallback: substring match
for item in data.get('items', []):
    if needle in item.get('title', '').lower():
        print(item['id'])
        sys.exit(0)
" "$title"
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
title="${2:-}"

case "$cmd" in
    add)
        require_title "$title"
        item_id=$(gh api graphql -f query="mutation {
            addProjectV2DraftIssue(input: {
                projectId: \"$PROJECT_ID\"
                title: \"$title\"
            }) { projectItem { id } }
        }" | python3 -c "import json,sys; print(json.load(sys.stdin)['data']['addProjectV2DraftIssue']['projectItem']['id'])")
        echo "added: $title ($item_id)"
        ;;

    start)
        require_title "$title"
        item_id=$(find_item_id "$title")
        [[ -n "$item_id" ]] || die "no item found matching: $title"
        set_status "$item_id" "$OPT_IN_PROGRESS"
        echo "in progress: $title"
        ;;

    done)
        require_title "$title"
        item_id=$(find_item_id "$title")
        [[ -n "$item_id" ]] || die "no item found matching: $title"
        set_status "$item_id" "$OPT_DONE"
        echo "done: $title"
        ;;

    todo)
        require_title "$title"
        item_id=$(find_item_id "$title")
        [[ -n "$item_id" ]] || die "no item found matching: $title"
        set_status "$item_id" "$OPT_TODO"
        echo "todo: $title"
        ;;

    list)
        gh project item-list "$PROJECT_NUMBER" \
            --owner "$OWNER" \
            --format json \
            -L 100 \
        | python3 -c "
import json, sys
data = json.load(sys.stdin)
for item in data.get('items', []):
    status = item.get('status', '?')
    title  = item.get('title', '')
    print(f'{status:15} | {title}')
"
        ;;

    *)
        echo "usage: board.sh <add|start|done|todo|list> [\"title\"]" >&2
        exit 1
        ;;
esac
