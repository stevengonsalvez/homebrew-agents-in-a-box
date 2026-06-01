class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.2.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.2.2/ainb-1.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "ed34a45fa8f87a321fcfbe7aee4f28597a7c1146342cee55a70fcc7e5948f72a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.2.2/ainb-1.2.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a3549ce42efebe0a2743362bd273584f192d3a6c1937b12f84efec7c30113338"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
