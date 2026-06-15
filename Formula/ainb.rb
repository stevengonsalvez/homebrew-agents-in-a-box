class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.7.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.2/ainb-1.7.2-aarch64-apple-darwin.tar.gz"
      sha256 "dfdb1110876222b8bf396fac2c19a65cdc50e83df3f2cbb988a3ca1eeb5cc2b0"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.2/ainb-1.7.2-x86_64-apple-darwin.tar.gz"
      sha256 "0b53d425ead6a85da2367c3e675745d0dcefd7c63378ebdcb862736eed82bf29"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.2/ainb-1.7.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e1d4f8910125f62984a372e0f7a6b0717fc451b91d5452218b4d2f374bc84e76"
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
