class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.4.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.4.0/ainb-1.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "076a58399b9c31daca7ae7309c589a32c2d6bb8e15a5a1a4526b1b0e75ae4027"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.4.0/ainb-1.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd9e30806d2f4ed2894a802f0e344e1e68976579f74ff5d931e667a67fbb661d"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
