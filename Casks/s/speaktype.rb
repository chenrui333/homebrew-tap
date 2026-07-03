cask "speaktype" do
  version "1.2.3"
  sha256 "22fb5c9ca91e60adfa50670598975061341f2068f1743eb3f17e12ed3573887b"

  url "https://github.com/karansinghgit/speaktype/releases/download/v#{version}/SpeakType-#{version}.dmg",
      verified: "github.com/karansinghgit/speaktype/"
  name "SpeakType"
  desc "Open-source offline voice dictation app"
  homepage "https://tryspeaktype.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "speaktype.app"

  zap trash: "~/Library/Preferences/com.2048labs.speaktype.plist"
end
