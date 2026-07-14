cask "lanes" do
  version "0.44.1"
  sha256 "bbf64c3bc4af25923eda6c3661c4dc53a5b0c63a29f89236aadc12591b064fc0"

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
