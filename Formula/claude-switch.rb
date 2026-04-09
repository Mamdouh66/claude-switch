class ClaudeSwitch < Formula
  desc "Fast profile switcher for Claude Code — swap accounts in under a second"
  homepage "https://github.com/Mamdouh66/claude-switch"
  url "https://github.com/Mamdouh66/claude-switch/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1eb72cb90db6070cb83ab0b13d8c2e4a211c8021ab2cd3d80cd15bbbdc57bace"
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
