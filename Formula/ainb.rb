class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.20.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.0/ainb-1.20.0-aarch64-apple-darwin.tar.gz"
      sha256 "58614a241dd3113e28bd685469222bfb57395144c0c344e7a0d9708ff1d8b395"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.0/ainb-1.20.0-x86_64-apple-darwin.tar.gz"
      sha256 "b250d62e06a9a76194c57a335b827f6171542310149eea8e90bc5c9a8db7afd7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.0/ainb-1.20.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "28c2ac74218c23138c49502f23bb6e4f6d5619cd3e9dd5164c1c61adb68f4418"
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
