# claude-switch shell integration
# Source this in your .zshrc: source /path/to/claude-switch.zsh

# Main wrapper: `c work`, `c personal`, `c status`, or just `c`
unalias c 2>/dev/null
c() {
  case "$1" in
    work|personal|status|refresh)
      if [[ "$1" == "status" || "$1" == "refresh" ]]; then
        claude-switch "$1"
      else
        claude-switch "$1" && command claude --dangerously-skip-permissions "${@:2}"
      fi
      ;;
    *)
      command claude --dangerously-skip-permissions "$@"
      ;;
  esac
}

# Tab completion for c
_c_completions() {
  local profiles=("work" "personal" "status" "refresh")
  # Add any other profiles from keychain
  local extra
  extra=($(claude-switch list 2>/dev/null))
  profiles=("${profiles[@]}" "${extra[@]}")
  # Deduplicate
  profiles=($(echo "${profiles[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
  COMPREPLY=($(compgen -W "${profiles[*]}" -- "${COMP_WORDS[COMP_CWORD]}"))
}

# Zsh completion
if [[ -n "$ZSH_VERSION" ]]; then
  _c_zsh_completions() {
    local profiles=("work" "personal" "status" "refresh")
    local extra
    extra=($(claude-switch list 2>/dev/null))
    profiles=("${profiles[@]}" "${extra[@]}")
    # Deduplicate
    profiles=($(echo "${profiles[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
    compadd -- "${profiles[@]}"
  }
  compdef _c_zsh_completions c
fi

# Show active profile in right prompt (optional — uncomment to enable)
# _claude_profile_rprompt() {
#   local profile
#   profile=$(cat ~/.claude/.active-profile 2>/dev/null)
#   if [[ -n "$profile" ]]; then
#     echo "%F{cyan}[claude:${profile}]%f"
#   fi
# }
# RPROMPT='$(_claude_profile_rprompt)'
