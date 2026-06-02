class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.3.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.3.2/ainb-1.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "8ab38d4785a2cd0ab86d7861f416189839ee28e5c273e84a0ea48c75ff95bd5b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.3.2/ainb-1.3.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fc6937eb167a615bfa44a5a4fffc7522e2f91210ab0dc1a00ae076cd7279055e"
    end
  end

  def install
    bin.install "ainb"
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
