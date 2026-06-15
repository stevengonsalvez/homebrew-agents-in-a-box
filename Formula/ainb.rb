class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.7.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.3/ainb-1.7.3-aarch64-apple-darwin.tar.gz"
      sha256 "1a4c5afb7ff1a5fdf2f5ec4b83d7ac29a4afb76e8078d3f91ab9d6b43c1e292d"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.3/ainb-1.7.3-x86_64-apple-darwin.tar.gz"
      sha256 "202dbf8c34a2d1509641614a4311d18d01d0779b11dd2e3dbe45e419b9ced4d6"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.3/ainb-1.7.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "74fdedf08a44efec8e9d2f81e494237979b1fed74a8edf317dac8ab5ef86a0d4"
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
