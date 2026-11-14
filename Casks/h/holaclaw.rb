cask "holaclaw" do
  version "1.7.1"
  sha256 :no_check

  url "https://downloads.holaclaw.ai/releases/latest/holaclaw_universal.dmg"
  name "HolaClaw"
  desc "Personal local-first AI assistants"
  homepage "https://holaclaw.ai/"

  livecheck do
    url "https://downloads.holaclaw.ai/releases/latest/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "holaclaw.app"

  uninstall launchctl: "dev.endor.holaclaw.vf-daemon"

  zap trash: [
    "~/Library/Application Support/HolaClaw",
    "~/Library/Caches/HolaClaw",
    "~/Library/Preferences/ai.holaclaw.app.plist",
  ]
end
