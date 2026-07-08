class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.14.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.14.0/ainb-1.14.0-aarch64-apple-darwin.tar.gz"
      sha256 "600bfea468062ef58e17b0b7355bfd1e96a69943088dae8374732f735ab936de"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.14.0/ainb-1.14.0-x86_64-apple-darwin.tar.gz"
      sha256 "dbc76f2d70823ff8899714221ce86eb05d9c0bb79d83a001b879496956310785"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.14.0/ainb-1.14.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d0361be78b33701584098d07aac102960c6b83478328a32d6ab38b69b2e09b61"
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
