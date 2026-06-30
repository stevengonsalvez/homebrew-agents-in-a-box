class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.10.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.10.1/ainb-1.10.1-aarch64-apple-darwin.tar.gz"
      sha256 "d6956d6ca2a6641ececda04649dd9dbc9c9918a79813941c7ad46177f010de0c"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.10.1/ainb-1.10.1-x86_64-apple-darwin.tar.gz"
      sha256 "6b7cab457fd2afa57a49a24414bff85da578df2cec51b9e3c3794477ff319844"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.10.1/ainb-1.10.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7c88eb3f0c1b004f509da55b85a06b0529f3a1db6b69b650351b016e9ad4fc3e"
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
