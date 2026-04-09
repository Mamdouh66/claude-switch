# claude-switch

Switching between Claude Code accounts sucks. You have to log out, log back in, wait, do it again when you want to switch back. If you have a work account and a personal account, you know the pain.

This fixes that. One command to switch, instant, done.

```
$ c status

  Profiles
  ────────────────────────────────────
  ● personal   max   1.7h left
  ○ work       team  7.2h left

$ c work
● Switched to work
```

Pure bash, zero dependencies, credentials stored securely in macOS Keychain.

## Install

### Homebrew

```bash
brew install Mamdouh66/tap/claude-switch
```

Then add to your `~/.zshrc`:

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

First install runs a guided setup automatically. You can also run it anytime with `claude-switch setup`.

It asks you to:
1. Pick a shortcut — `c`, `cc`, `code`, whatever you want
2. Name your accounts — call them anything, not limited to "work" and "personal"
3. Add as many accounts as you need

Or do it manually:

```bash
# You're logged into your first account
claude-switch save work

# Log into the other one
claude auth logout && claude auth login
claude-switch save personal
```

## Usage

```bash
c work              # switch to work + launch claude
c personal          # switch to personal + launch claude
c status            # show all profiles and token health
c refresh           # refresh active profile's token
c                   # launch claude with current profile
c -p "hello"        # any flags pass through to claude
```

The shortcut name is configurable:

```bash
claude-switch alias cc    # now it's `cc work`, `cc status`, etc.
```

All commands also work directly:

```bash
claude-switch <profile>         # switch to a profile
claude-switch status            # show profiles and token health
claude-switch setup             # guided setup wizard
claude-switch save <name>       # save current credentials as a profile
claude-switch list              # list profile names
claude-switch remove <name>     # delete a profile
claude-switch refresh           # refresh active token
claude-switch alias [name]      # show or change shell shortcut
```

## Token refresh

Claude Code uses OAuth tokens that expire after about 8 hours. Here's how claude-switch deals with that:

- **When you switch away** from a profile, it saves the current credentials (which Claude may have silently refreshed during your session) back to that profile's Keychain entry.
- **When you switch to** a profile with an expired token, it automatically triggers a refresh and saves the new token.
- **`claude-switch refresh`** lets you manually refresh the active profile whenever you want.

This keeps things working smoothly as long as you switch between profiles regularly.

> **Important**: There's a separate **refresh token** that Claude Code uses behind the scenes to get new access tokens. This refresh token lasts much longer (weeks/months), but if you don't use a profile for a very long time and the refresh token expires, you'll need to log in again with `claude auth login` and re-save the profile with `claude-switch save <name>`. In normal use this shouldn't happen.

## Requirements

- macOS (uses Keychain for secure credential storage)
- Claude Code CLI installed and authenticated
- bash or zsh

## License

MIT
