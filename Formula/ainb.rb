class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.20.6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.6/ainb-1.20.6-aarch64-apple-darwin.tar.gz"
      sha256 "d79bb49aaf9009653d152ef568c4032db4f5fedd5d5a9e1c20fff6d969cc590f"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.6/ainb-1.20.6-x86_64-apple-darwin.tar.gz"
      sha256 "cb8649d74c2bcc63268cbf102e25d63f85f191be6da441ab526d06156aa15c2d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.6/ainb-1.20.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b988eb5563c450a3fb03c4070d53d8173421d1668a8791a672b8c4e53bbc5ff7"
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
