class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.21.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.0/ainb-1.21.0-aarch64-apple-darwin.tar.gz"
      sha256 "495151998676e4d30b39e74d1c376ba6d8372fbced906ddb8e4ad3b55ef675e6"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.0/ainb-1.21.0-x86_64-apple-darwin.tar.gz"
      sha256 "b966b97ddcde7be67fbc87b4348d6fc5345275a87ceb4312f92816b89c2469ca"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.0/ainb-1.21.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "82c5aa308d14f5770f72fa8fcde6627443f9f592eeb2f37432ce02068dc17bea"
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
    # ainb(1). Guarded so this formula still installs an older
    # tarball that predates the man page.
    man1.install "share/man/man1/ainb.1" if File.exist?("share/man/man1/ainb.1")
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
