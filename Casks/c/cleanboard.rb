cask "cleanboard" do
  version "2.4.3"
  sha256 "36df753e1a775d6daf970a38f8e8ff491ebdbe4592d22965f16349deee359cbf"

  url "https://github.com/tompodab/cleanboard/releases/download/#{version}/CleanBoard-#{version}-Installer.dmg"
  name "CleanBoard"
  desc "Lightweight app that removes formatting from copied text by hitting copy twice"
  homepage "https://cleanboard.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "CleanBoard.app"

  zap trash: [
    "~/Library/Application Support/com.tompod.cleanboard",
    "~/Library/HTTPStorages/com.tompod.cleanboard",
    "~/Library/Preferences/com.tompod.cleanboard.plist",
    "~/Library/Preferences/com.tompod.cleanboard.revenuecat.etags.plist",
  ]
end
