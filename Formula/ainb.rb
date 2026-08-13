class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.20.9"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.9/ainb-1.20.9-aarch64-apple-darwin.tar.gz"
      sha256 "f14afe5fc2a97223dfce752ff2865d1035bbc9a8fd480a7fceb7a43c97f757b5"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.9/ainb-1.20.9-x86_64-apple-darwin.tar.gz"
      sha256 "6ba3b2aaf8651a39a5654b9caaaeb9b272844125d9739071e76986dae82b91f7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.9/ainb-1.20.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f7c1edf0e80717e5f12e18ea743c2bfea5cd5961f16522cf260633b2b913a9b9"
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
