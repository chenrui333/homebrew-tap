cask "lanes" do
  version "0.45.4"
  sha256 "bc9f81930186e57f12cfbfec4fab8da68f00eb0c4def71c658ca7519ea5f91fa"

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
