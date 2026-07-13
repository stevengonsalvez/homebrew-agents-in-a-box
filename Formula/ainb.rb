class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.15.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.15.0/ainb-1.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "b2b6ffe391d344d7c23c09ba5ad9e703e8f9561055a72f189f4ed1a35a6b0e22"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.15.0/ainb-1.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "fae8ab25b7fb7a12faac51e3d16ade65373fe74773b5a19a280ba4e9d64790e8"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.15.0/ainb-1.15.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7996f6455c9234852f76d1c50771402c6966e6f051eddcfd47a8bf9ca4e87ba4"
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
