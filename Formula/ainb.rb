class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.3.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.3.3/ainb-1.3.3-aarch64-apple-darwin.tar.gz"
      sha256 "205d694fd452299a6e977d7ac36c31f4f80c3d58e91de369e21073b96b3eab71"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.3.3/ainb-1.3.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "32e6769df69545fa81d8b5796b5fc4bb35a7792e7551bc5a141b00f791427505"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
