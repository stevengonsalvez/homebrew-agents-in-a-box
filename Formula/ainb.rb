class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.3.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.3.0/ainb-1.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "766c609a9c393bb816952e05b57a852cd5cd0731d59e7973eefa80380f6b1cf7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.3.0/ainb-1.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f7ff4b867c70221bc063e149e0092520b5bd56f1b629ad707d527deed039e33c"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
