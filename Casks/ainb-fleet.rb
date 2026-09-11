cask "ainb-fleet" do
  version "1.28.2"
  sha256 "b5630e94709f7bc98b6752c78e61aff6de3497fbbff1b376bfe1eca6046cbf6b"

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
