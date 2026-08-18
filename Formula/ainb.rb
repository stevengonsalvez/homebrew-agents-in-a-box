class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.21.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.2/ainb-1.21.2-aarch64-apple-darwin.tar.gz"
      sha256 "38f59d4520d7c583ce7d5db8e9719212d1d075f92b7c80a83a90ccc639725b5e"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.2/ainb-1.21.2-x86_64-apple-darwin.tar.gz"
      sha256 "98a586a4d4f3bf9bb6e956a807cc97c41799b7b241c16295bf5c9750ef4e8d80"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.2/ainb-1.21.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1ea5325acbe851f79013d9153fd5964f90cae2b5d8492b409558e9f90d04ddb0"
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
