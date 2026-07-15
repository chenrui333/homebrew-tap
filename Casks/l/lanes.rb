cask "lanes" do
  version "0.44.5"
  sha256 "ebcc80f3d4e36c54915a6191ef181bafe704ec5cc3b92bcf19333b99a196c755"

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
