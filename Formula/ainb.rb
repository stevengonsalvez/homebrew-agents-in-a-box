class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.21.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.3/ainb-1.21.3-aarch64-apple-darwin.tar.gz"
      sha256 "8403197bf26eecaaa190c77cfa69a060db24d175d6fb2d4d09766252d01cad2e"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.3/ainb-1.21.3-x86_64-apple-darwin.tar.gz"
      sha256 "f280e26842b659434a96e183a54d0e2c86a14278cf4a5a229c609897c498868d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.3/ainb-1.21.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "91bab290937bfcb8fe102bce8d8a28ed8a5e25dd9c750429a64efe757ef6554f"
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
