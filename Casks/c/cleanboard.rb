cask "cleanboard" do
  version "2.5.6"
  sha256 "2330b9889b43aea9cf45cac6a9f483cef88094dc4cab1b7f127f0ec67234a158"

  url "https://github.com/tompodab/cleanboard/releases/download/#{version}/CleanBoard-#{version}.dmg"
  name "CleanBoard"
  desc "Lightweight app that removes formatting from copied text by hitting copy twice"
  homepage "https://cleanboard.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "CleanBoard.app"

  zap trash: [
    "~/Library/Application Support/com.tompod.cleanboard",
    "~/Library/HTTPStorages/com.tompod.cleanboard",
    "~/Library/Preferences/com.tompod.cleanboard.plist",
    "~/Library/Preferences/com.tompod.cleanboard.revenuecat.etags.plist",
  ]
end
