class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.21.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.8/ainb-1.21.8-aarch64-apple-darwin.tar.gz"
      sha256 "714b6fc2954c57dbb28c323b484bbdbca777084b3930d0d89052c2d61419ce3d"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.8/ainb-1.21.8-x86_64-apple-darwin.tar.gz"
      sha256 "dbf3bce0496696ee99fad5fa982d455998881bb61ed5728dec75e318ed90eb24"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.8/ainb-1.21.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dd30b3cbc4534af9a3a21b21f51ef512402ecfe59a88b47b78dbc97b4a8582f1"
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
