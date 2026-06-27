class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.9.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.5/ainb-1.9.5-aarch64-apple-darwin.tar.gz"
      sha256 "db166306a33187a92b757f68f61f5f2b2e09429ffdeebb5902ade54b3c9f5da0"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.5/ainb-1.9.5-x86_64-apple-darwin.tar.gz"
      sha256 "48d6fd3d632dd52d8024dfd8278391e8e8a7bb4e36668c4ccd0e51fa69fdb6e6"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.5/ainb-1.9.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "807e1ddd9cb4c639268b1f52e0e0587e22af5a6875a8cbddbc07e9c975281fe1"
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
