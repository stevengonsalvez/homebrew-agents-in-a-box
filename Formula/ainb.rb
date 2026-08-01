class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.18.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.18.0/ainb-1.18.0-aarch64-apple-darwin.tar.gz"
      sha256 "e90cddd0d7a03225d7cbdc0700b685155c6dcfae2cb6dac17c43e42a17fea3cd"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.18.0/ainb-1.18.0-x86_64-apple-darwin.tar.gz"
      sha256 "0b5fba69f2e02d9c150c2d0697f9f0bba8480ccd7b13ee566bbd56907f417a35"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.18.0/ainb-1.18.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "81151fadedced5050a0800a7387ceeebb8c1bb567ce09edc440e5add7d0c2997"
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
