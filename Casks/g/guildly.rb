cask "guildly" do
  version "0.1.74"
  sha256 "3b7059d407b484e32daa8b7b122df05a1021cefc02ceb5ef37b630cf3a76c656"

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
