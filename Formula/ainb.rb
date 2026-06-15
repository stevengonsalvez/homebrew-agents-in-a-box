class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.7.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.4/ainb-1.7.4-aarch64-apple-darwin.tar.gz"
      sha256 "efd1caa9dac63ac87ce5d88dd36ccc3154b86516c9f87f37a28dda7d9657798e"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.4/ainb-1.7.4-x86_64-apple-darwin.tar.gz"
      sha256 "836eaefec6d11831bef6f236236da32175efadf6fff6990209db65652ccac684"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.7.4/ainb-1.7.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e303ece6094f8f7286f1c45f364627ec6ea66241e6e389d1019024e4039c6dcb"
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
