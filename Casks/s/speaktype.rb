cask "speaktype" do
  version "1.3.0"
  sha256 "2aa7ec1a7e67631825e5bc045b875f49e28fb408de8b301cfbeadb3528891c2d"

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
