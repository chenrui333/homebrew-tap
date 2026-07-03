cask "speaktype" do
  version "1.2.2"
  sha256 "f293c5c80b538c3981567fd37839476b7958cc05b2ec6315d31ba65b8f7176ac"

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
