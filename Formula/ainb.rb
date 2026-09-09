class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.26.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.26.1/ainb-1.26.1-aarch64-apple-darwin.tar.gz"
      sha256 "25b90b88ad11f734597ae40f2a3f2094b5656fdcd5c078d0ca3cc84a19a0841a"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.26.1/ainb-1.26.1-x86_64-apple-darwin.tar.gz"
      sha256 "b4ac5c3f69176abb1d7336b6e732689cde878bd09887601ab9e496b98926e3fc"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.26.1/ainb-1.26.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1ad45f0d0bac382001d79a51bd69b5f3baf2cf37e775f4aa07fe0cf93ebdeec6"
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
      # This value names a keg-versioned path, so an older install's
      # export outlives the keg. Inherited from a long-lived shell or
      # a tmux server environment it survives `brew upgrade` and then
      # either points at a directory the upgrade deleted (every plugin
      # screen comes up empty) or, until `brew cleanup` runs and
      # removes the old keg, still resolves — pairing this binary with
      # the PREVIOUS release's plugin binaries.
      #
      # Drop any inherited value naming a different ainb keg, whether
      # or not it still exists. A genuine user override (any path not
      # under an ainb Cellar keg) is untouched.
      case "${AINB_PLUGIN_ROOT}" in
        "" ) ;;
        "#{libexec}/plugins" ) ;;
        */Cellar/ainb/* ) unset AINB_PLUGIN_ROOT ;;
        * ) [ -d "${AINB_PLUGIN_ROOT}" ] || unset AINB_PLUGIN_ROOT ;;
      esac
      export AINB_PLUGIN_ROOT="${AINB_PLUGIN_ROOT:-#{libexec}/plugins}"
      exec "#{libexec}/ainb" "$@"
    WRAPPER
    (bin/"ainb").chmod 0755
  end

  test do
    assert_match "ainb", shell_output("#{bin}/ainb --version")
  end
end
