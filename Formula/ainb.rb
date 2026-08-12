class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.20.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.5/ainb-1.20.5-aarch64-apple-darwin.tar.gz"
      sha256 "e8504e3f5f681becb4445e2fd0729233d072296776ceaf62093d630193025428"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.5/ainb-1.20.5-x86_64-apple-darwin.tar.gz"
      sha256 "3ab5ad59dfcdcc36f9b29c172552eb2ef4f7e36802d70d429d02f5ce35193f36"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.5/ainb-1.20.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ec5a7c3175507513e9ec2a41879e7968f4c555dd5bd43ef40525de5304868cd9"
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
