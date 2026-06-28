cask "speaktype" do
  version "1.1.0"
  sha256 "9189a6c1a53cfc68f32005f36b2475a20dd084cacf8c52b63b720eccb9f11e40"

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
