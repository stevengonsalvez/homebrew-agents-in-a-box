class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.21.6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.6/ainb-1.21.6-aarch64-apple-darwin.tar.gz"
      sha256 "e85f52be68d59ecbad048dca805834d68590bdf7f704228d9e6eba0265085a94"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.6/ainb-1.21.6-x86_64-apple-darwin.tar.gz"
      sha256 "a25f11bf94b1574db0d644bfa1b3b2674b55ffeb792ff7fc2cebf9c5f8d87419"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.6/ainb-1.21.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8502290541689e413b979539d7620d3463159c6e3034bc53d3f57a303e39d384"
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
