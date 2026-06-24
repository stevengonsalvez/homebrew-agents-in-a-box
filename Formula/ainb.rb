class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.9.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.3/ainb-1.9.3-aarch64-apple-darwin.tar.gz"
      sha256 "33d5abcfed08ab1c20ea47a099d1c772d944756746d14f8eeeacbefbb167860e"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.3/ainb-1.9.3-x86_64-apple-darwin.tar.gz"
      sha256 "aaf7752a8bf407dd36fec0620721c2f47323cb5d24c942bf7d4335392b2ac678"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.3/ainb-1.9.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "33d600c911caf6185127e39061a50585653951f812c971a97fee270f92da0c2d"
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
