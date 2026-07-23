class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.16.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.16.1/ainb-1.16.1-aarch64-apple-darwin.tar.gz"
      sha256 "17c04a2070525f7a6f576622ca2e196c105aead76fe0c43544a737c946c0fc0a"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.16.1/ainb-1.16.1-x86_64-apple-darwin.tar.gz"
      sha256 "f948bab7e75f13111fe3c4f7787a6be9e2f3fc20e607871b19875b19424f40d5"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.16.1/ainb-1.16.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9025fa71e06da420d25fdea301aed04fd11a6770cf217d64faaca4f7c5f7517e"
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
