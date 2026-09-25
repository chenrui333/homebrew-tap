cask "lanes" do
  version "0.49.5"
  sha256 "9cb2fd2c1dd331f6166722730557dbcb251dbcb5e265d190b970196a872c2a53"

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
