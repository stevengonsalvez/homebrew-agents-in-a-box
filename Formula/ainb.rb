class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.2.0/ainb-1.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "a1b43e0d358361873d12c69b9e1ede8aa749a310f9b1d8f2d57f01183faa7652"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.2.0/ainb-1.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "308155cf9d3ab45a1d8662c7a88605349dc09ebf420dedc70e644cc50bae3dbc"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
