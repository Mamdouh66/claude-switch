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
claude-switch mode [name]       # show or set storage mode (keychain|isolated)
```

## Storage modes

claude-switch has two ways of keeping accounts apart. The default suits most people; the alternative trades a little convenience for stronger isolation.

### `keychain` (default)

One shared Claude Code login lives in the macOS Keychain, and switching swaps a saved snapshot of each account's credentials in and out of it. Zero setup beyond `claude-switch setup`, and a bare `claude` always uses whatever you last switched to. Only one account is "active" globally at a time.

### `isolated`

Each profile gets its own `CLAUDE_CONFIG_DIR`, so it has a completely separate login, its own refresh token, and its own history/settings. Benefits:

- **Run accounts side by side** — different profiles in different terminals, simultaneously. Keychain mode can't do this.
- **Rotation-safe** — each profile's refresh token rotates in place where it lives, so there's no stale-snapshot hazard (see below).

Trade-off: switching only affects the shell you run it in (it exports `CLAUDE_CONFIG_DIR` for that shell), and the first launch of each profile prompts you to log in.

```bash
claude-switch mode isolated     # turn it on
claude-switch work              # create the 'work' profile
c work                          # launch it — Claude prompts you to log in (first time only)
c personal                      # different account, even in another terminal at the same time
claude-switch mode keychain     # switch back anytime
```

## Token refresh

Claude Code uses OAuth tokens that expire after about 8 hours. Here's how claude-switch deals with that:

- **When you switch away** from a profile, it saves the current credentials (which Claude may have silently refreshed during your session) back to that profile's Keychain entry.
- **When you switch to** a profile with an expired token, it automatically triggers a refresh and saves the new token.
- **`claude-switch refresh`** lets you manually refresh the active profile whenever you want.

This keeps things working smoothly as long as you switch between profiles regularly.

> **Important**: There's a separate **refresh token** that Claude Code uses behind the scenes to get new access tokens. This refresh token lasts much longer (weeks/months), but if you don't use a profile for a very long time and the refresh token expires, you'll need to log in again with `claude auth login` and re-save the profile with `claude-switch save <name>`. In normal use this shouldn't happen.

> **Heads up (keychain mode)**: refresh tokens are increasingly rotated/single-use. Because keychain mode swaps *snapshots* of credentials, if you sign into the same account elsewhere (another machine, the web app) between switches, an older snapshot can hold a refresh token that's since been rotated away — restoring it then forces a re-login. Switching between your profiles regularly avoids this, and `isolated` mode sidesteps it entirely since each profile renews its own token in place.

In `status`, a profile shown as **`auto-refresh`** (not a time like `1.7h left`) just means its cached access token has lapsed but the refresh token will mint a new one on next use — it's healthy, not broken. Only a profile with no refresh token shows **`expired`**.

## Requirements

- macOS (uses Keychain for secure credential storage)
- Claude Code CLI installed and authenticated
- bash or zsh

## License

MIT
