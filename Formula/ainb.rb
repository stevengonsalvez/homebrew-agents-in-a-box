class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.22.7"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.7/ainb-1.22.7-aarch64-apple-darwin.tar.gz"
      sha256 "1ed7671bc5a18e14f255aed29347da073b527e460ebd66e95e4acc0de0653750"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.7/ainb-1.22.7-x86_64-apple-darwin.tar.gz"
      sha256 "39f33be22051d8fdf05dfc57e18d9fd4854945708ee6bc66f8dcbbc2c63a3d35"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.22.7/ainb-1.22.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "01441dbe28088f08d11e4395fba270686e9e92fcb528e876e4efedbfe876c494"
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
