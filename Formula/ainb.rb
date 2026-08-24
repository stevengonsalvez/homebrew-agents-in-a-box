class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.22.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.1/ainb-1.22.1-aarch64-apple-darwin.tar.gz"
      sha256 "ede3ec187fba359d9ce4c83bac768f364ec6fd8b68ff88da6d1590096e0ff027"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.1/ainb-1.22.1-x86_64-apple-darwin.tar.gz"
      sha256 "09560306f1b343aaf5f079618f74e468a4fb07ea7cae4d0ed3c7254663f40043"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.1/ainb-1.22.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b48cbab0b848f01cceefea4691443e73ea615538bd6349ac04f7eca630fd9ea3"
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
