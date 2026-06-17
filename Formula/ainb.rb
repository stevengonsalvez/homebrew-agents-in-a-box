class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.7.7"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.7/ainb-1.7.7-aarch64-apple-darwin.tar.gz"
      sha256 "0200fe039190e1964090643f8bd6598d6e5fe6cc55c7e07c2c71012b5b62c2b8"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.7/ainb-1.7.7-x86_64-apple-darwin.tar.gz"
      sha256 "d1fb9836325e49ca612b87e9b32d9969179299b90bf019a21a18d78e42fa3b35"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.7/ainb-1.7.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "850d2c6a6e7c529dededae9b0cc957606ac708bfe7fe220f11c04e593cb9deb0"
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
