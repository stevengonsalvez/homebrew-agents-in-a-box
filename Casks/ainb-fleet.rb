cask "ainb-fleet" do
  version "1.28.4"
  sha256 "4bd459122a25bcc31e83a1b953695637257e22e01810235b4574907668b94cbc"

  url "https://github.com/stevengonsalvez/agents-in-a-box/releases/download/v#{version}/AINBFleet-#{version}.dmg"
  name "AINB Fleet"
  desc "Menu bar control plane for AINB sessions"
  homepage "https://github.com/stevengonsalvez/agents-in-a-box"

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "AINBFleet.app"

  caveats <<~EOS
    AINB Fleet is unsigned. On first launch, right-click AINBFleet.app and choose Open.
    Or choose Open Anyway in System Settings > Privacy & Security.
  EOS
end
