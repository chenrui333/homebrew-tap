cask "guildly" do
  version "0.1.84"
  sha256 "b3a970f226bf9951b3da76d2eda1694ef6a608a9b247c2fb3f357d5d76cd5544"

  url "https://github.com/shoebum-goyell/guildly-releases/releases/download/v#{version}/Guildly-#{version}-arm64.dmg",
      verified: "github.com/shoebum-goyell/guildly-releases/"
  name "Guildly"
  desc "Run a team of AI employees with human-in-the-loop control"
  homepage "https://www.tryguildly.com/"

  depends_on arch: :arm64
  depends_on macos: :big_sur

  app "Guildly.app"

  zap trash: [
    "~/Library/Application Support/Guildly",
    "~/Library/Caches/Guildly",
    "~/Library/Preferences/com.guildly.app.plist",
  ]
end
