#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: herdr-workspace [OPTIONS]

Select or create an Afforester worktree, then focus its Herdr workspace.

Options:
  -p, --project PATH       Existing worktree or Afforester .tree project root
  -n, --name NAME          Worktree name when creating from a .tree root
      --pull               Pull while Afforester creates the worktree
      --agent claude|codex Start the selected agent in the workspace root pane
  -h, --help               Show this help
EOF
}

project_path=
worktree_name=
pull=0
agent_kind=

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--project)
      [[ $# -ge 2 ]] || { printf 'Missing value for %s\n' "$1" >&2; exit 2; }
      project_path=$2
      shift 2
      ;;
    -n|--name)
      [[ $# -ge 2 ]] || { printf 'Missing value for %s\n' "$1" >&2; exit 2; }
      worktree_name=$2
      shift 2
      ;;
    --pull)
      pull=1
      shift
      ;;
    --agent)
      [[ $# -ge 2 ]] || { printf 'Missing value for --agent\n' >&2; exit 2; }
      case "$2" in
        claude|codex) agent_kind=$2 ;;
        *) printf 'Unsupported agent: %s (expected claude or codex)\n' "$2" >&2; exit 2 ;;
      esac
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$project_path" ]]; then
  project_path=$(find "$HOME/Projects" -mindepth 3 -maxdepth 4 -type d -print 2>/dev/null | fzf --height 40% --reverse) || exit 0
fi

[[ -d "$project_path" ]] || {
  printf 'Project path is not a directory: %s\n' "$project_path" >&2
  exit 1
}

if [[ "$(basename "$project_path")" == *.tree ]]; then
  create_args=(--project "$project_path")
  (( pull )) && create_args+=(--pull)
  [[ -n "$worktree_name" ]] && create_args+=("$worktree_name")

  worktree_json=$(git-afforester --json worktree create "${create_args[@]}")
  worktree_path=$(jq -er '.path // empty' <<<"$worktree_json") || {
    printf 'Afforester did not return a worktree path.\n' >&2
    exit 1
  }
else
  [[ -z "$worktree_name" ]] || {
    printf '--name is only valid when creating from a .tree project root.\n' >&2
    exit 2
  }
  (( pull == 0 )) || {
    printf '--pull is only valid when creating from a .tree project root.\n' >&2
    exit 2
  }
  worktree_path=$project_path
fi

worktree_path=$(realpath "$worktree_path")
[[ -d "$worktree_path" ]] || {
  printf 'Resolved worktree path is not a directory: %s\n' "$worktree_path" >&2
  exit 1
}

workspace_id=
workspace_list=$(mktemp)
trap 'rm -f "$workspace_list"' EXIT
herdr workspace list --json >"$workspace_list"
jq -e '.result.workspaces | arrays' "$workspace_list" >/dev/null || {
  printf 'Herdr workspace list returned an unexpected JSON schema.\n' >&2
  exit 1
}

while IFS=$'\t' read -r candidate_id candidate_cwd; do
  [[ -n "$candidate_id" && -n "$candidate_cwd" ]] || continue
  [[ -d "$candidate_cwd" ]] || continue
  if [[ "$(realpath "$candidate_cwd")" == "$worktree_path" ]]; then
    workspace_id=$candidate_id
    break
  fi
done < <(jq -er '.result.workspaces[]? | [(.workspace_id // .id // empty), (.cwd // empty)] | @tsv' "$workspace_list")

if [[ -n "$workspace_id" ]]; then
  herdr workspace focus "$workspace_id"
  workspace_result=$(herdr workspace get "$workspace_id")
else
  workspace_result=$(herdr workspace create \
    --cwd "$worktree_path" \
    --label "$(basename "$worktree_path")" \
    --focus)
  workspace_id=$(jq -er '.result.workspace.workspace_id // .result.workspace_id // empty' <<<"$workspace_result")
fi

if [[ -n "$agent_kind" ]]; then
  pane_id=$(jq -er '.result.root_pane.pane_id // .result.workspace.root_pane.pane_id // .result.workspace.root_pane_id // empty' <<<"${workspace_result:-$(herdr workspace get "$workspace_id")}")
  herdr agent start "$agent_kind" --kind "$agent_kind" --pane "$pane_id"
fi
