class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.2.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.2.1/ainb-1.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "e3e3710fe32c6208d7c4c5b2538ac155de8ff2fa33a61379d7c77ed6f25ba70a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.2.1/ainb-1.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ccce205cb9c0725c5509ade0d0ec16dbb09fcb7442a931a177afdc721c1c32d6"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
