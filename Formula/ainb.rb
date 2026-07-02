class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.11.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.11.1/ainb-1.11.1-aarch64-apple-darwin.tar.gz"
      sha256 "e0953caa4d7c4b6deb8d50b8f7ba04e3cd06cd402c78ae8c49c3cc157a478cf9"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.11.1/ainb-1.11.1-x86_64-apple-darwin.tar.gz"
      sha256 "c02616db35e9cfc008e07e8d186db4cd41b3eb2698d25306331cc199de69117d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.11.1/ainb-1.11.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "49c6867c830851c71d13bc7b348b498a5c017748c9d07702831255c8fceb813c"
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
