cask "lanes" do
  version "0.49.6"
  sha256 "f87f1a7d490257669783ea7fa7546387495c4fddb0bc119b64c09f91ad35794a"

  url "https://github.com/lanes-sh/app/releases/download/v#{version}/Lanes_#{version}_universal.dmg"
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
