class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.9.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.4/ainb-1.9.4-aarch64-apple-darwin.tar.gz"
      sha256 "cabca7e544a369f0dc69b686521afe9e13bdcb3221864f1f41bebdab629b4db2"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.4/ainb-1.9.4-x86_64-apple-darwin.tar.gz"
      sha256 "a8e5a55f82f5dccf71a7b3bcfb3b4f8e6e3dd36f9c96770da73aba6267768982"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.4/ainb-1.9.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "75cbe85ca8584ff8157aa36a1022856176135181003414e93fd2a71afa0eceb4"
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
