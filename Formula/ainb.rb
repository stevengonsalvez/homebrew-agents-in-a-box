class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.22.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.0/ainb-1.22.0-aarch64-apple-darwin.tar.gz"
      sha256 "26a0f98b7c48f6132ac7c4ce99da04b3d0d3aad5f142040d75a2188a1e439ba1"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.0/ainb-1.22.0-x86_64-apple-darwin.tar.gz"
      sha256 "9b78da2edbbe4021aab91bd8828d5ba24171ca48360b3eeaeee0f92f35d9de6e"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.0/ainb-1.22.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d3e37b6a6baf691e132093466317069ee5695d13fe15ca6ee0e8bbeb878524b5"
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
