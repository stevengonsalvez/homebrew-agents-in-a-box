class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.7.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.0/ainb-1.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "9759f0295952e2fa2a17b49788d6479298b7659c050d8d0415a0ef0217a26be0"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.0/ainb-1.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "3cc701e718921fb3996df969c01abc05f4ae6584d6fea909f35fdff4dd2d11d4"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.0/ainb-1.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "39907d4fcf26cda1e864e30d8b459a9ed34c6183973cc10ab47c0e9eaf0179be"
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
