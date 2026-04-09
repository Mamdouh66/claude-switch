class ClaudeSwitch < Formula
  desc "Fast profile switcher for Claude Code — swap accounts in under a second"
  homepage "https://github.com/Mamdouh66/claude-switch"
  url "https://github.com/Mamdouh66/claude-switch/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "92ff1d71de6c02ae4975cc9a00d1f9ac11406250c7d81f75a631b030b675fc5e"
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
