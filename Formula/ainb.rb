class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.21.7"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.7/ainb-1.21.7-aarch64-apple-darwin.tar.gz"
      sha256 "4a9725eccc45e92761330302a1b66e654e8bd872391c1925e49d58432d5a429b"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.7/ainb-1.21.7-x86_64-apple-darwin.tar.gz"
      sha256 "53adefcfe8d77c1c78d58ac16544d4142da12a3e7c27ff27115a9b1279c03f28"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.7/ainb-1.21.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bf099402834c954dc19af9dcb65b2499df4ffea4f5eae0b7ab8227ab35214675"
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
