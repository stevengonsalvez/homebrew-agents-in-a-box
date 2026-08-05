class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.18.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.18.1/ainb-1.18.1-aarch64-apple-darwin.tar.gz"
      sha256 "330170397ff74dcbcb1e4dbd3dcdd99ab169f4098f30dabafe8fb78d0a81de20"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.18.1/ainb-1.18.1-x86_64-apple-darwin.tar.gz"
      sha256 "b02db7cfb52fb73ceb4c1b895a804d7845c00c97e9b51f0eb7d20cf23fa618f9"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.18.1/ainb-1.18.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4009f0149cb413ef53f6e6312d8b2f98f8878caef4c5d2c57f8c3ba66327e446"
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
