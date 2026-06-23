class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.9.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.0/ainb-1.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "e87933837834405b1abfabdc7a36d533c2a320e17c02cc3bfd09ef2ebeced387"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.0/ainb-1.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "b149ab0e493620067a9da8d8a9871f249a32de7621eca2e521b3618066860be3"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.0/ainb-1.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2092d79d475eaf5ec121740d63f78529737efdabde91beb9f7d1c0286bb14ada"
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
