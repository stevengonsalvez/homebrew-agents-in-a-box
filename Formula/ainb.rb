class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.9.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.1/ainb-1.9.1-aarch64-apple-darwin.tar.gz"
      sha256 "e660ae67fa914c1ad383a2bd44be4be68acc6bd7a7fed012c3a0961c17162bfe"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.1/ainb-1.9.1-x86_64-apple-darwin.tar.gz"
      sha256 "1c4efa13bd084a6e11bebedcd8107cf7ea4f87ff13efca0f13150cbba7b8d782"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.9.1/ainb-1.9.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3cc4e5168a264ca962758342ee91384f62876c0ef7e7df71fc128df592d0f461"
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
