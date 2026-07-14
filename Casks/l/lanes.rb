cask "lanes" do
  version "0.44.4"
  sha256 "bc50a9cb7f1e640f1f8bc7499127ee224ff45899ace9b3057874d57d67768ffc"

  url "https://github.com/lanes-sh/app/releases/download/v#{version}/Lanes_#{version}_universal.dmg",
      verified: "github.com/lanes-sh/app/"
  name "Lanes"
  desc "Mission control for parallel AI coding agents"
  homepage "https://lanes.sh/"

  depends_on macos: :ventura

  app "Lanes.app"

  zap trash: [
    "~/Library/Application Support/Lanes",
    "~/Library/Caches/Lanes",
    "~/Library/Preferences/sh.lanes.app.plist",
  ]
end
