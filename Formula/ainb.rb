class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.20.7"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.7/ainb-1.20.7-aarch64-apple-darwin.tar.gz"
      sha256 "97318abcc27e10b132afb4a999b3273f7e95d5f34e9b0712fc9ba2f023ccac17"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.7/ainb-1.20.7-x86_64-apple-darwin.tar.gz"
      sha256 "fcabeab739668a0400c534947908f4dfaf888f6f8767a65155c5eb6188c12286"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.7/ainb-1.20.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d64eab146ff12f29e2dbc5396f4addc55fe1cc4f33c2b209d5b0f51737500ff5"
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
    # ainb(1). Guarded so this formula still installs an older
    # tarball that predates the man page.
    man1.install "share/man/man1/ainb.1" if File.exist?("share/man/man1/ainb.1")
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
