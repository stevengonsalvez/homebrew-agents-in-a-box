class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.22.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.2/ainb-1.22.2-aarch64-apple-darwin.tar.gz"
      sha256 "8ceb4ba775c784d6790191473293da449661e43bc2971f7954e963e728f6736e"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.2/ainb-1.22.2-x86_64-apple-darwin.tar.gz"
      sha256 "e29311700edec625899092aaf0dd38e1aa83ed3e4cfcdc22512709c2b771b563"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.2/ainb-1.22.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9d0047c6229adc8eee022880a0c673fc7f4499fe3e41f128f21ec9901490d1d4"
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
