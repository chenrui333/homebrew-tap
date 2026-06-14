cask "holaclaw" do
  version "1.2.0"
  sha256 :no_check

  url "https://downloads.holaclaw.ai/releases/latest/holaclaw_universal.dmg"
  name "HolaClaw"
  desc "Personal local-first AI assistants"
  homepage "https://holaclaw.ai/"

  depends_on macos: :ventura
  depends_on arch: :arm64

  app "holaclaw.app"

  zap trash: [
    "~/Library/Application Support/HolaClaw",
    "~/Library/Caches/HolaClaw",
    "~/Library/Preferences/ai.holaclaw.app.plist",
  ]
end
