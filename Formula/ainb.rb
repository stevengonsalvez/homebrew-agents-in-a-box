class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.20.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.3/ainb-1.20.3-aarch64-apple-darwin.tar.gz"
      sha256 "8f88a4fd73382c13dda9fd52d1a4c746ca203e5cba9aa9d27c21899b22be4de0"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.3/ainb-1.20.3-x86_64-apple-darwin.tar.gz"
      sha256 "ea2a882b2d62090b2edd9edc11bcc990c2f948e6e39ec04d2c5a60298121d61b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.3/ainb-1.20.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f60297d7fd5f1d391064368c5c4a1ecea34236cd81d510381503d53b913d0258"
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
