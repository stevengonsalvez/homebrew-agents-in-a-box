class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.4.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.4.3/ainb-1.4.3-aarch64-apple-darwin.tar.gz"
      sha256 "d3065ab3b6b61dfd8ffeaf0e95f04a941ecb8a025f228b9f9accfcbfc7d3b3d1"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.4.3/ainb-1.4.3-x86_64-apple-darwin.tar.gz"
      sha256 "f5fdd4d3f79ce3f0a1f07cbf9469bb1e98977c0180bad52409c60adba9c16519"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.4.3/ainb-1.4.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fccf3cc2899ee36cc4407a0bea8a93df474d52c5d0b2950d836973cce5fd402b"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
