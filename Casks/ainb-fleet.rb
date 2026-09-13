cask "ainb-fleet" do
  version "1.28.5"
  sha256 "ac86fda81f44b9b2e1c723c6cbfdd2bbef678bfb7639e6ac9757545e7d4c0c52"

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
