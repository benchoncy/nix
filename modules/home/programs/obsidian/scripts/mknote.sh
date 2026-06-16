#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'mknote: %s\n' "$*" >&2
  exit 1
}

show_help() {
  cat <<'EOF'
Usage: mknote [OPTIONS] [NOTE...]
       command | mknote [OPTIONS]

Append a timestamped entry to today's Obsidian daily note.

Options:
  -w, --work   Write to work/journal/YYYY/MM-MMM/YYYY-MM-DD.md
  -h, --help   Show this help
  --           Treat remaining arguments as note text

Default destination:
  journal/YYYY/MM-MMM/YYYY-MM-DD.md

Environment:
  OBSIDIAN_VAULT  Override vault path (default: ~/Documents/Obsidian/main)

Examples:
  mknote "remember this"
  mknote -w "follow up with team"
  printf 'captured from stdin' | mknote -w
  mknote -- -starts-with-dash
  mknote -w
EOF
}

vault="${OBSIDIAN_VAULT:-$HOME/Documents/Obsidian/main}"

if [[ -z "$vault" ]]; then
  fail "Obsidian vault path is empty"
fi

today_year="$(date '+%Y')"
today_month="$(date '+%m-%b')"
today_date="$(date '+%Y-%m-%d')"
today_time="$(date '+%H:%M:%S')"
weekday="$(date '+%A')"

note_kind="personal"
note_heading='# Notes'
note_path="$vault/journal/$today_year/$today_month/$today_date.md"

while (($# > 0)); do
  case "$1" in
    -w|--work)
      note_kind="work"
      note_heading='# Work Notes'
      note_path="$vault/work/journal/$today_year/$today_month/$today_date.md"
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
  esac
done

ensure_note() {
  local note_path="$1"
  local note_heading="$2"
  local note_dir
  note_dir="$(dirname "$note_path")"

  mkdir -p "$note_dir" || fail "failed to create journal directory: $note_dir"

  if [[ ! -e "$note_path" ]]; then
    if [[ "$note_kind" == "work" ]]; then
      cat >"$note_path" <<EOF
---
day_of_week: $weekday
tags: [work]
---

$note_heading

EOF
    else
      cat >"$note_path" <<EOF
---
day_of_week: $weekday
---

$note_heading

EOF
    fi
  elif [[ ! -f "$note_path" ]]; then
    fail "daily note path exists but is not a file: $note_path"
  fi
}

append_entry() {
  local content="$1"
  local note_path="$2"
  local note_heading="$3"

  if [[ ! "$content" =~ [^[:space:]] ]]; then
    printf 'mknote: nothing to append\n' >&2
    return 0
  fi

  ensure_note "$note_path" "$note_heading"
  {
    printf '[%s] ' "$today_time"
    printf '%s\n' "$content"
  } >>"$note_path" || fail "failed to append to daily note: $note_path"
  printf 'mknote: appended to %s\n' "$note_path" >&2
}

if (($# > 0)); then
  append_entry "$*" "$note_path" "$note_heading"
  exit 0
fi

if [[ ! -t 0 ]]; then
  stdin_content="$(cat)" || fail "failed to read stdin"
  append_entry "$stdin_content" "$note_path" "$note_heading"
  exit 0
fi

editor="${VISUAL:-${EDITOR:-nvim}}"
tmp_file="$(mktemp "${TMPDIR:-/tmp}/mknote.XXXXXX")" || fail "failed to create temp file"
trap 'rm -f "$tmp_file"' EXIT

read -r -a editor_command <<<"$editor"
"${editor_command[@]}" "$tmp_file" || fail "editor failed: $editor"
editor_content="$(cat "$tmp_file")" || fail "failed to read temp file"
append_entry "$editor_content" "$note_path" "$note_heading"
