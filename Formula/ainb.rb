class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.3.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.3.1/ainb-1.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "183a04c22c00f6c52341a0370e7f07c7bf090ce4131765927ed10cc50deedf5f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.3.1/ainb-1.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "986d28eb99e341faf9d7350858401f3f6d7ed8603a696139f1da94c9c70337be"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
