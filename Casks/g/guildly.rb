cask "guildly" do
  version "0.1.71"
  sha256 "153465d1ba8dd8dec0c187903ee5b2086f3e30dc2da809c21e99ecbfe071276e"

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
