class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.22.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.5/ainb-1.22.5-aarch64-apple-darwin.tar.gz"
      sha256 "f5dc9e305784e9c18a12f237e360e9e67b3c1604b0a350ae97bdee671c781667"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.5/ainb-1.22.5-x86_64-apple-darwin.tar.gz"
      sha256 "66bc75800d737fc4080e5b59987baf454cd1566ac43a7d20ebfca21b7f1280df"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.5/ainb-1.22.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b9c395861098f2b074ac0b395a31d58e2a2e930e36bdf25ca9f22c766654360a"
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
