class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.7.6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.6/ainb-1.7.6-aarch64-apple-darwin.tar.gz"
      sha256 "f92af96b8122e17e9d6a2c2daea28793a7f89134781fae7cf48ba6bc613c2cf3"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.6/ainb-1.7.6-x86_64-apple-darwin.tar.gz"
      sha256 "c6e39fe74fd8257cdfea432b22189f5467195c7877d01ec1b97ba7eae88f0a12"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.6/ainb-1.7.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d378cd885871c2f92df0425ef4a65623ebf719b7f17f80cbf0994e52362b4a86"
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
