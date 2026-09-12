cask "ainb-fleet" do
  version "1.28.3"
  sha256 "a7fe21fbd50493b47ec4816d367ab4e416fbf20c5ab0ed11571e7c562db92b82"

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
