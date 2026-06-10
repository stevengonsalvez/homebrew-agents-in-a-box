class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.6.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.6.0/ainb-1.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "143bd11a6fa4589b5da1fa4c9761c275376d57f18ac3857f908a791f40d5cac2"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.6.0/ainb-1.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "86736db7487f7f7c04ad3bbd3c459b252f272cca2d914959c75c700ea5ec999d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.6.0/ainb-1.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5fcff823320f869ab139522366b9a6fc09641cc75b719646128917909085320d"
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
