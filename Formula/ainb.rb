class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.22.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.4/ainb-1.22.4-aarch64-apple-darwin.tar.gz"
      sha256 "65392dbf17952afbb6c6c371d951f62b8d359e25aa4e88f579d5548fb30fbe3d"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.4/ainb-1.22.4-x86_64-apple-darwin.tar.gz"
      sha256 "cace9a18b685e9682865a8307504c14acf1afcaf74cfb93f2e65445b13afc815"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.4/ainb-1.22.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "72a613c967f81a90f76b2c8c417a6bbf2a9ebf16cb4b1c246f5ce197f4b5abc9"
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
