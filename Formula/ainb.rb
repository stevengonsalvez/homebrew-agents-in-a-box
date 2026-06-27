class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.9.6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.6/ainb-1.9.6-aarch64-apple-darwin.tar.gz"
      sha256 "beef970738f027d9e145583c243d53231c904ff8d88a107db9430a74365f384d"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.6/ainb-1.9.6-x86_64-apple-darwin.tar.gz"
      sha256 "db060fe05eb12bb3cc5088f6e54b1ec98f51659677adf0917357977871b48990"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.6/ainb-1.9.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "11d02ad48a2ac0454ee345b85ea1a78b23bbbb17261f783001c5620761aab028"
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
