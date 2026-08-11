class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.20.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.1/ainb-1.20.1-aarch64-apple-darwin.tar.gz"
      sha256 "46514a7ad0430495e3573725f9cd574b3e17c9d6da35f17f81d334e462b77b9c"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.1/ainb-1.20.1-x86_64-apple-darwin.tar.gz"
      sha256 "acd7d0de3c849305beab11e95439c926b8129695170253a7723a49909b469035"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.1/ainb-1.20.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dd781e415ad95f8460cc0572e08b347836c1d46a61542b8d1f28b3fc76627059"
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
