# claude-switch

Fast profile switcher for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) on macOS. Zero dependencies, pure bash, credentials stored in macOS Keychain.

Switch between Claude accounts in under a second — no logout/login cycles.

```
$ c status

  Profiles
  ────────────────────────────────────
  ● personal   max   1.7h left
  ○ work       team  7.2h left

$ c work
● Switched to work
```

## How it works

Claude Code stores OAuth credentials in the macOS Keychain under `Claude Code-credentials`. This tool saves copies of those credentials under profile-specific entries (`Claude Code-credentials-work`, etc.) and swaps them when you switch.

On switch it:
1. Auto-saves the current profile's (possibly refreshed) credentials
2. Loads the target profile's credentials into the main slot
3. Refreshes expired tokens automatically via `claude auth status`
4. Tracks the active profile in `~/.claude/.active-profile`

## Install

### Homebrew (recommended)

```bash
brew install Mamdouh66/tap/claude-switch
```

Then add this to your `~/.zshrc`:

```bash
source $(brew --prefix)/share/claude-switch.zsh
```

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/Mamdouh66/claude-switch/main/install.sh | bash
```

### From source

```bash
git clone https://github.com/Mamdouh66/claude-switch.git
cd claude-switch
./install.sh
```

## Setup

The installer runs a guided setup automatically on first install. You can also run it anytime:

```bash
claude-switch setup
```

It walks you through:
1. **Choosing your shortcut** — `c`, `cc`, `code`, or whatever you like
2. **Naming your accounts** — any names you want, not just work/personal
3. **Adding multiple accounts** — save as many as you need

Or set up manually:

```bash
# Save your current login as a profile
claude-switch save work

# Log into another account, then save it too
claude auth logout && claude auth login
claude-switch save personal
```

## Usage

### Shell shortcut (recommended)

The install adds a shortcut function to your shell (default: `c`, configurable):

```bash
c work              # switch to work + launch claude
c personal          # switch to personal + launch claude  
c status            # show all profiles and token health
c refresh           # refresh active profile's token
c                   # launch claude with current profile
c -p "hello"        # pass any flags through to claude
```

Change the shortcut anytime:

```bash
claude-switch alias cc     # now it's `cc work`, `cc status`, etc.
```

### Direct commands

```bash
claude-switch <profile>         # switch to a profile
claude-switch status            # show all profiles and token health
claude-switch setup             # guided setup wizard
claude-switch save <name>       # save current credentials as a profile
claude-switch list              # list profile names
claude-switch remove <name>     # delete a profile
claude-switch refresh           # refresh active token
claude-switch alias [name]      # show or change shell shortcut
```

## Token refresh

OAuth tokens expire after ~8 hours. claude-switch handles this automatically:

- **On switch away**: saves the current (possibly refreshed) credentials before loading the new profile
- **On switch to**: if the target token is expired, runs `claude auth status` to trigger a refresh and saves the result
- **Manual**: `claude-switch refresh` refreshes the active profile on demand

Tokens stay fresh as long as you use your profiles regularly. If a profile sits unused for a long time, the refresh token will handle it on next switch.

## Requirements

- macOS (uses Keychain for secure credential storage)
- Claude Code CLI installed and authenticated
- bash or zsh

## How is this different from claude-swap?

[claude-swap](https://github.com/realiti4/claude-swap) is a Python package that does the same thing. This project is:

- **Zero dependencies** — pure bash, no Python runtime needed
- **Faster** — no interpreter startup, instant switch
- **Proactive token refresh** — automatically refreshes expired tokens on switch
- **Shell-native** — configurable shortcut with tab completion
- **Guided setup** — interactive wizard, not just docs

## License

MIT
