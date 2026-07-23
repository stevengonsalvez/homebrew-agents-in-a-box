class Ainb < Formula
  desc "Terminal-based development environment manager for Claude Code agents"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"
  license "MIT"
  version "1.16.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.16.0/ainb-1.16.0-aarch64-apple-darwin.tar.gz"
      sha256 "9d3e2febb79642b541476f5f5bdd34525389d68f0c5498b6ad7e9ee596a35108"
    else
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.16.0/ainb-1.16.0-x86_64-apple-darwin.tar.gz"
      sha256 "724d0563eb457b1c4ec8aea6fc4af9bed67d46fcb6f331da0f0b32933f65c2cc"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v1.16.0/ainb-1.16.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c2bfc75eabf2776086bfd3ee6e96e5077547b0fbd2015405b5ed9476dc42e47a"
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
