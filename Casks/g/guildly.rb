cask "guildly" do
  version "0.1.94"
  sha256 "123f37ae5829a22fa85341c727fcd85d906bac94bc13a3a5a3cf1dcbc5cc4796"

  url "https://github.com/shoebum-goyell/guildly-releases/releases/download/v#{version}/Guildly-#{version}-arm64.dmg"
  name "Guildly"
  desc "Run a team of AI employees with human-in-the-loop control"
  homepage "https://www.tryguildly.com/"

  depends_on arch: :arm64
  depends_on macos: :big_sur

  app "Guildly.app"

  uninstall quit: "com.guildly.desktop"

  zap trash: [
    "~/Library/Application Support/Guildly",
    "~/Library/Caches/Guildly",
    "~/Library/Preferences/com.guildly.app.plist",
  ]
end
