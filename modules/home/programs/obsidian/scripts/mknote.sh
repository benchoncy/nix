#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'mknote: %s\n' "$*" >&2
  exit 1
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
note_path="$vault/journal/$today_year/$today_month/$today_date.md"

ensure_note() {
  local note_dir
  note_dir="$(dirname "$note_path")"

  mkdir -p "$note_dir" || fail "failed to create journal directory: $note_dir"

  if [[ ! -e "$note_path" ]]; then
    cat >"$note_path" <<EOF
---
day_of_week: $weekday
---

# Notes

EOF
  elif [[ ! -f "$note_path" ]]; then
    fail "daily note path exists but is not a file: $note_path"
  fi
}

append_entry() {
  local content="$1"

  if [[ ! "$content" =~ [^[:space:]] ]]; then
    printf 'mknote: nothing to append\n' >&2
    return 0
  fi

  ensure_note
  {
    printf '[%s] ' "$today_time"
    printf '%s\n' "$content"
  } >>"$note_path" || fail "failed to append to daily note: $note_path"
  printf 'mknote: appended to %s\n' "$note_path" >&2
}

if (($# > 0)); then
  append_entry "$*"
  exit 0
fi

if [[ ! -t 0 ]]; then
  stdin_content="$(cat)" || fail "failed to read stdin"
  append_entry "$stdin_content"
  exit 0
fi

editor="${VISUAL:-${EDITOR:-nvim}}"
tmp_file="$(mktemp "${TMPDIR:-/tmp}/mknote.XXXXXX")" || fail "failed to create temp file"
trap 'rm -f "$tmp_file"' EXIT

read -r -a editor_command <<<"$editor"
"${editor_command[@]}" "$tmp_file" || fail "editor failed: $editor"
editor_content="$(cat "$tmp_file")" || fail "failed to read temp file"
append_entry "$editor_content"
