class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.4.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.4.4/ainb-1.4.4-aarch64-apple-darwin.tar.gz"
      sha256 "08d61e4dd781fdeced50758b260126318c4656aab85c1ab132ba519aa2cf0a95"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.4.4/ainb-1.4.4-x86_64-apple-darwin.tar.gz"
      sha256 "81e44720502d94067b4d117240fe454513afdd2dfadfde3716da213e7349ec3d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.4.4/ainb-1.4.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2ab7a12927e474838010da6e4862e632c04da95070073926ad1b7d200e29aed9"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
