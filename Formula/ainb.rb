class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.9.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.2/ainb-1.9.2-aarch64-apple-darwin.tar.gz"
      sha256 "4fa0cff149d722dd01949dd50782ac8b5a7648f63a93f34fb59400f31651a0ab"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.2/ainb-1.9.2-x86_64-apple-darwin.tar.gz"
      sha256 "e643cd0a938b14bd3ecd79b37def2a6e0d1c7122c1e396efa732423f0ae93cbf"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.2/ainb-1.9.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "10176a2a421e106dfe0fcd786fbbefbefcf3c8185632eaec2b40e7c8297c5616"
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
