class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.22.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.3/ainb-1.22.3-aarch64-apple-darwin.tar.gz"
      sha256 "e3eccdd6031f499ac5855b0e902c3533380935ca144440f1bd196f2264459477"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.3/ainb-1.22.3-x86_64-apple-darwin.tar.gz"
      sha256 "08d4b0f7f07af75f7c3896afd207012188f296acda222966c037f0482752ed8d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.3/ainb-1.22.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "06b3ff5c50f1c9bbc4725aeb4c034feb2690d9f15de04bf49ab999c2b086876c"
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
