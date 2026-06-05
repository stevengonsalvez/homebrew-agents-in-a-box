class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.4.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.4.2/ainb-1.4.2-aarch64-apple-darwin.tar.gz"
      sha256 "d83aed402186e717fd567f3ee7d9f53c33cacf1725e2ad69abaad3c424648cb8"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.4.2/ainb-1.4.2-x86_64-apple-darwin.tar.gz"
      sha256 "f45bf4a5f864cb6aaceb28d410a1a95644dd0b54d57f3e6188a4f713530839f9"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.4.2/ainb-1.4.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "66558a7c57888f5b8196e5263874f77a334e2420544590e46bfe34e425e6b224"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
