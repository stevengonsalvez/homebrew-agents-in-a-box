class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.17.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.17.0/ainb-1.17.0-aarch64-apple-darwin.tar.gz"
      sha256 "50cd9f9387ae29b28cd537d6317b20a1ab0934db7653b7f416e27f68cb2f5879"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.17.0/ainb-1.17.0-x86_64-apple-darwin.tar.gz"
      sha256 "649dc22c5d15445bead60271672b9aed6ec8806113abd5fd570d8f1f05c437c6"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.17.0/ainb-1.17.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4d63ff2edd8f4d629b6285e6707e5dc16991e0e5495d4837b9deebaf30f6133c"
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
