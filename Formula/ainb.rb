class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.13.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.13.0/ainb-1.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "cb2c1844d4fccf8051865a7a8fe059d0d721e5b654fc0b076650dc0990452cd6"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.13.0/ainb-1.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "af496154f0ad54bc6a61ff7cd9b64e74abc9841f87a9f405d2f7b963926c758b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.13.0/ainb-1.13.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e812039a078f4b410792b8d3f9d2672afda0d13d51fe0fdc4724b138335ab685"
    end
  end

  def install
    # Real binary + bundled first-party plugins live in libexec;
    # bin gets a thin env wrapper pointing the plugin runtime at
    # them. `ainb plugin install` is not shipped yet, so without
    # this a brew install has no analytics plugins at all. A
    # user-set AINB_PLUGIN_ROOT still wins.
    libexec.install "ainb"
    libexec.install "plugins" if File.directory?("plugins")
    (bin/"ainb").write <<~WRAPPER
      #!/bin/bash
      export AINB_PLUGIN_ROOT="${AINB_PLUGIN_ROOT:-#{libexec}/plugins}"
      exec "#{libexec}/ainb" "$@"
    WRAPPER
    (bin/"ainb").chmod 0755
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
