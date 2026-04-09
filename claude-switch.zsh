# claude-switch shell integration
# Source this in your .zshrc: source /path/to/claude-switch.zsh

_claude_switch_config_dir="$HOME/.config/claude-switch"

# Read alias name from config (default: c)
_claude_switch_alias() {
    if [ -f "$_claude_switch_config_dir/config" ]; then
        grep "^alias=" "$_claude_switch_config_dir/config" 2>/dev/null | head -1 | cut -d'=' -f2-
    fi
}

_claude_switch_register() {
    local alias_name="${1:-c}"

    # Define the function dynamically
    eval "
${alias_name}() {
    local cmd=\"\$1\"
    case \"\$cmd\" in
        status|refresh|setup)
            claude-switch \"\$cmd\"
            ;;
        *)
            # Check if it's a saved profile name
            if [ -n \"\$cmd\" ] && claude-switch list 2>/dev/null | grep -qx \"\$cmd\"; then
                claude-switch \"\$cmd\" && command claude --dangerously-skip-permissions \"\${@:2}\"
            else
                command claude --dangerously-skip-permissions \"\$@\"
            fi
            ;;
    esac
}
"

    # Zsh completion
    if [[ -n "$ZSH_VERSION" ]]; then
        eval "
_${alias_name}_completions() {
    local commands=(status refresh setup)
    local profiles=(\$(claude-switch list 2>/dev/null))
    compadd -- \"\${commands[@]}\" \"\${profiles[@]}\"
}
compdef _${alias_name}_completions ${alias_name}
"
    fi
}

# Register the alias
_cs_alias=$(_claude_switch_alias)
_claude_switch_register "${_cs_alias:-c}"
unset _cs_alias
