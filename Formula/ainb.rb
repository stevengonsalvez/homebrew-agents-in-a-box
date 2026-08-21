class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.21.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.4/ainb-1.21.4-aarch64-apple-darwin.tar.gz"
      sha256 "51d7591960913f97122a30026eac39d899793662dda60bb35dff4135e7f9d497"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.4/ainb-1.21.4-x86_64-apple-darwin.tar.gz"
      sha256 "a0c3cf597f012b269b3737fade262a63cf10d74c98619d9579f0a4a4751ccd33"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.21.4/ainb-1.21.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "059643b9b4944dbb4489a90535ea7e6241675fbe9f7324ff7c605b1579f3e4aa"
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
