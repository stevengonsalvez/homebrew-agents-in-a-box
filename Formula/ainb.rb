class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.1.0/ainb-1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "dfe45129da928a27009c5f8f6442edc7a45f2ea2bf69baa415d3f6daa9d56b9f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.1.0/ainb-1.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "130c53865df2a213cf477dc4e32e5b23c4121d87ee8387f7efa5b1d2cd14e64c"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
