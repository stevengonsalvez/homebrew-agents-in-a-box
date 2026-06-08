class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.5.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.5.0/ainb-1.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "4ff3f77567de3401302603116341ff9fcf8b064d0889d024a0d60195c7e4a32d"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.5.0/ainb-1.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "997b0ee68b8f75da2010d479b8af26bf605e2756a9a85a51f3a87539d5224d4a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.5.0/ainb-1.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "263deb38e394b255244de68ac3320a14e18649deba75122affbb7d883341f85f"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
