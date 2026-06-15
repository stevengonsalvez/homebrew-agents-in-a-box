class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.7.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.1/ainb-1.7.1-aarch64-apple-darwin.tar.gz"
      sha256 "d518ed1624ca81d0bff1f0bd4a7cb9c1a798aaf7c1e18ed29eeaf4cd4ed446c9"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.1/ainb-1.7.1-x86_64-apple-darwin.tar.gz"
      sha256 "5f943d7224fddafc59cb7d6f743017bae56390298bc371e6969ad64f99679637"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.1/ainb-1.7.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "385206e72c17a31484090d2d56e41886df3b41d2e7efe883da4ca55b3e56b1d3"
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
