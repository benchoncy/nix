SHELL_NAME=$(basename $SHELL)

alias g="git" # [g]it
alias gp="git pull && git push" # [g]it [p]ull and push
alias gs="git status" # [g]it [s]tatus
alias ga="git add" # [g]it [a]dd
alias gaa="git add ." # [g]it [a]dd [a]ll
alias gc="git commit" # [g]it [c]ommit
alias gac="git commit -a" # [g]it [a]dd and [c]ommit

gaf() {
  if [[ $# -eq 0 ]]; then
    command git-afforester
    return $?
  fi

  if [[ "$1" == "switch" || "$1" == "-s" || "$1" == "--switch" ]]; then
    shift
    local target_path
    if ! target_path=$(command git-afforester worktree resolve "$@"); then
      return $?
    fi
    if [[ -z $target_path ]]; then
      return 0
    fi
    cd "$target_path" || return
    return 0
  fi

  if [[ "$1" == "worktree" && "$2" == "create" ]]; then
    shift 2
    local switch_after_create=0
    local create_args=()
    while [[ $# -gt 0 ]]; do
      case "$1" in
        -s|--switch)
          switch_after_create=1
          ;;
        *)
          create_args+=("$1")
          ;;
      esac
      shift
    done

    local created_path
    if ! created_path=$(command git-afforester worktree create "${create_args[@]}"); then
      return $?
    fi

    if [[ $switch_after_create -eq 1 ]]; then
      if [[ -z $created_path ]]; then
        return 0
      fi

      local created_project
      local created_name
      created_project=$(dirname "$created_path")
      created_name=$(basename "$created_path")

      local resolved_path
      if ! resolved_path=$(command git-afforester worktree --project "$created_project" resolve "$created_name"); then
        return $?
      fi
      if [[ -z $resolved_path ]]; then
        return 0
      fi

      cd "$resolved_path" || return
      return 0
    fi

    if [[ -n $created_path ]]; then
      printf '%s\n' "$created_path"
    fi
    return 0
  fi

  command git-afforester "$@"
}

gafn() {
  gaf worktree create "$@"
}
