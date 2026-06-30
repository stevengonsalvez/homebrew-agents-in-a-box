class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.10.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.10.0/ainb-1.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "93752dbc750fe5cd512fa9eb093a2420b67592f620db529800bd381414942a8d"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.10.0/ainb-1.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "3c75b3313278a805e54430817f56ea44a752559de38ab4078e040d84dde1ce8d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.10.0/ainb-1.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "44fcf39bbc00b2f0881eb79f584635215c87e84a96de378e4f4a25d4a131c86f"
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
