class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.19.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.19.0/ainb-1.19.0-aarch64-apple-darwin.tar.gz"
      sha256 "d947c754126ea00df9a34fca875808162886d83934fb5dfe9695190eeeb6ac41"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.19.0/ainb-1.19.0-x86_64-apple-darwin.tar.gz"
      sha256 "f95aab9bb9f4f2692905b0b1294d4c5015bb23a61a2502c78d5404a067e491ee"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.19.0/ainb-1.19.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e3c167eda22aa5456f269957a4c242262a27ffce5d1e14e37b44dfbe15960c00"
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
