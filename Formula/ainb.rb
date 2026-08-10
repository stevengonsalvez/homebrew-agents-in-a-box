class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.20.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.2/ainb-1.20.2-aarch64-apple-darwin.tar.gz"
      sha256 "c14eb8cf76a345934e7f0a0e4c0fb51fabca7d588ead4a6d62e2960bd6990a2f"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.2/ainb-1.20.2-x86_64-apple-darwin.tar.gz"
      sha256 "46c5609bd2235b897c77de12ba4af63d39bb26719dcf49354d26b84b7e53646a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.20.2/ainb-1.20.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b2e8e8e0989d3eada19a75c1fb7e1b2330c649ea2d957679d2494b291dea32b7"
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
