class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.12.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.12.0/ainb-1.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "d8f4559940b5fdccf4e0c2bd790004ad7a52dedd611b4e9692120b56a6bc1206"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.12.0/ainb-1.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "bd00432296322da37a1e60ad6d0fe3f2a8e06a5baeaf336af0bfde927402f7bc"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.12.0/ainb-1.12.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c74fc88a107cdfdb04e33bf9c953ca7268edea743b8d5a8fcfc69040958ef5ec"
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
