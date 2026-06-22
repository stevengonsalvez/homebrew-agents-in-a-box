class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.8.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.8.1/ainb-1.8.1-aarch64-apple-darwin.tar.gz"
      sha256 "d79f773e03f0b8310327a426101496409cfa5371e98a7ddcdeb6ceeefa41a1e6"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.8.1/ainb-1.8.1-x86_64-apple-darwin.tar.gz"
      sha256 "90427476070e339245a5d989b23434753b30c4d49230229362d18b764de00071"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.8.1/ainb-1.8.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "169d8a0d6706ab5faf64bb7be6c12f4882f0c71cd6478c0394f51c299c7dec04"
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
