cask "cleanboard" do
  version "2.4.2"
  sha256 "9acba69030aa10849aa3f1aad7e0c43d4e3241b08e2d0b225cd295778b39f8c4"

  url "https://github.com/tompodab/cleanboard/releases/download/#{version}/CleanBoard-#{version}-Installer.dmg",
      verified: "github.com/tompodab/cleanboard/"
  name "CleanBoard"
  desc "Lightweight app that removes formatting from copied text by hitting copy twice"
  homepage "https://cleanboard.app/"

  app "CleanBoard.app"

  zap trash: [
    "~/Library/Application Support/CleanBoard",
    "~/Library/Caches/com.cleanboard.app",
    "~/Library/Preferences/com.cleanboard.app.plist",
  ]
end
