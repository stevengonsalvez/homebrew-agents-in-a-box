class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.7.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.5/ainb-1.7.5-aarch64-apple-darwin.tar.gz"
      sha256 "7433083b15737ef96a6d5db7346947051088aa468f964102fbda53612da38e45"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.5/ainb-1.7.5-x86_64-apple-darwin.tar.gz"
      sha256 "dc7afeccd359bc0d183eff238686c41c92651e026ce7ebddd880b24fb7062fec"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.5/ainb-1.7.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0708d60d0152ab7cc2f145973bfd90831bba149fd2cd212c7238057250a5a85f"
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
