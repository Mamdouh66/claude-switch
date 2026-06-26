class ClaudeSwitch < Formula
  desc "Fast profile switcher for Claude Code — swap accounts in under a second"
  homepage "https://github.com/Mamdouh66/claude-switch"
  url "https://github.com/Mamdouh66/claude-switch/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "0047a7e250e0052527a1c7b7a51f18b1e8b0d4378abc584ad53e53514e0c9414"
  license "MIT"

  depends_on :macos

  def install
    bin.install "claude-switch"
    share.install "claude-switch.zsh"
  end

  def caveats
    <<~EOS
      Add this to your ~/.zshrc:

        source #{share}/claude-switch.zsh

      Then run:

        claude-switch setup
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/claude-switch --help", 1)
  end
end
