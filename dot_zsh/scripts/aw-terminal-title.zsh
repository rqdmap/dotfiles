# aw-terminal-title.zsh
# Keep terminal window title useful for ActivityWatch / aw-watcher-window
# Source this file from ~/.zshrc, do not execute it as a standalone script

# This file is zsh-specific. It uses add-zsh-hook, ${(z)...}, and $commands
[[ -n "$ZSH_VERSION" ]] || return 0 2>/dev/null || exit 0

autoload -Uz add-zsh-hook
zmodload zsh/parameter 2>/dev/null

_aw_title_is_command_boundary() {
  emulate -L zsh

  [[ "$1" == "|"  ||
     "$1" == "||" ||
     "$1" == "&&" ||
     "$1" == ";"  ||
     "$1" == "&"  ||
     "$1" == "("  ||
     "$1" == ")"  ]]
}

_aw_title_first_bin() {
  emulate -L zsh

  local line="$1"
  local -a words
  words=("${(z)line}")

  local w path

  for w in "${words[@]}"; do
    if _aw_title_is_command_boundary "$w"; then
      break
    fi

    # Skip simple-command leading environment assignments, e.g. NODE_ENV=prod npm run build
    if [[ "$w" =~ '^[A-Za-z_][A-Za-z0-9_]*=' ]]; then
      continue
    fi

    # Skip zsh precommand modifiers
    case "$w" in
      noglob|time|command|exec)
        continue
        ;;
    esac

    # Explicit path: ./foo, ../foo, /usr/local/bin/foo
    if [[ "$w" == */* ]]; then
      print -rn -- "${w:t}"
      return
    fi

    # External executable from zsh's command hash, equivalent to PATH resolution without forking
    path="${commands[$w]}"
    if [[ -n "$path" ]]; then
      print -rn -- "${path:t}"
    else
      # Builtin/function/reserved word/unresolved command, preserve the original word
      print -rn -- "$w"
    fi
    return
  done

  print -rn -- "shell"
}

_aw_title_escape() {
  emulate -L zsh

  local s="$1"
  s=${s//$'\a'/}
  s=${s//$'\e'/}
  print -rn -- "$s"
}

_aw_title_set() {
  emulate -L zsh

  local title="$(_aw_title_escape "$1")"
  print -Pn "\e]2;${title}\a"
}

_aw_title_project_name() {
  emulate -L zsh

  local root name
  root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -n "$root" ]]; then
    name="${root:t}"
  else
    name="${PWD:t}"
    [[ -z "$name" ]] && name="/"
  fi

  print -rn -- "$name"
}

_aw_title_preexec() {
  emulate -L zsh

  # $2 is the single-line, alias-expanded command; $1 is the raw input
  local line="${2:-$1}"
  local bin="$(_aw_title_first_bin "$line")"
  local project="$(_aw_title_project_name)"

  _aw_title_set "${bin} · ${project}"
}

_aw_title_precmd() {
  emulate -L zsh

  _aw_title_set "$(_aw_title_project_name)"
}

add-zsh-hook preexec _aw_title_preexec
add-zsh-hook precmd _aw_title_precmd
