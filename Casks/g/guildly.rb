cask "guildly" do
  version "0.1.69"
  sha256 "a4c4b77c363bf41fa337b0dadc5fbeee6f6a7d0171a4ab8e2673292f9b49b160"

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
