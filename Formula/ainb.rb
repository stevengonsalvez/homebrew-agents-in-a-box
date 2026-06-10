class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.6.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.6.1/ainb-1.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "80f2307b5a8780b57410bef09cd5ac52a1423f10a158be2139b733f8c70bdfdb"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.6.1/ainb-1.6.1-x86_64-apple-darwin.tar.gz"
      sha256 "820134dd2809fc8b9ebff0826b5d522f65e65be7f9240ff54dbce9a35e61dfde"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.6.1/ainb-1.6.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7d935f803bf69614f78f0f4d20333a07065059d16259ba43c82b34760a986854"
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
