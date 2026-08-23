class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.21.9"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.9/ainb-1.21.9-aarch64-apple-darwin.tar.gz"
      sha256 "1587269d6708cbcbc7d42708d1a7c26eb12029ac6aa6dab196c2025c4194d6c3"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.9/ainb-1.21.9-x86_64-apple-darwin.tar.gz"
      sha256 "54d501db52807e7c732fa44551715d4c29e708ca31aba2073b696c926a30698f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.9/ainb-1.21.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "38e2701a2f09bf4a177bf1a90a8b248c22225eb373e8514bfe50d810a30e2903"
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
