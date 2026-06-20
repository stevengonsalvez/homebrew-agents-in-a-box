class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.8.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.8.0/ainb-1.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "609866c28934e906c4b888c60e6006273aed4024b3bf0e8d0c201a50a4f5ee22"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.8.0/ainb-1.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "e07d9aa0b4932542750afaa739d1b10d64c81a663001cea6a7874def27a29339"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.8.0/ainb-1.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "478ddabf6e22cc24ec47e56695d038642891e0668e337b1b3d9be1c7eee980f6"
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
