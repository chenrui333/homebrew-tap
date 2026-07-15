cask "guildly" do
  version "0.1.89"
  sha256 "ddfa892110d36c3f636ab168919515b29694cb1a4d31549c9a56cc3fe6bd493f"

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
