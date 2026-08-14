class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.21.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.1/ainb-1.21.1-aarch64-apple-darwin.tar.gz"
      sha256 "4acab5c2ab924fe7b245d96eca457329c0fcace637b61b34fcb4340b019ca141"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.1/ainb-1.21.1-x86_64-apple-darwin.tar.gz"
      sha256 "e6127311173ccc7b80fafdae6c87f59f51ddeba0ec3f19464bc89cf6f555ba76"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.1/ainb-1.21.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d62fb1e291d756af4d9b4c31f47776febd087fe698b85ff3270a85edda1b58cf"
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
