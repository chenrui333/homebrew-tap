cask "lanes" do
  version "0.45.2"
  sha256 "7929057b4560d5a4448b9d97508ac962e373cf5cbc0795b5746e7118f8893e86"

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
