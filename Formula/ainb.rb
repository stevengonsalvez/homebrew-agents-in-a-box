class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.20.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.8/ainb-1.20.8-aarch64-apple-darwin.tar.gz"
      sha256 "dc15d87f008d23a6ebb9ab2769505269a9a87a125b44b464f95949f7a43fc691"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.8/ainb-1.20.8-x86_64-apple-darwin.tar.gz"
      sha256 "f0a2e0e3d9d497489b0953c2ca718dfc3b7818bf75f57faccf5182889f0aeb05"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.8/ainb-1.20.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "779c14b9487251358232ad5d027f33186fcb0c7d4c0cc12ef9621c870bcb291a"
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
