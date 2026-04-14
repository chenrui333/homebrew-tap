cask "speaktype" do
  version "1.0.29"
  sha256 "c3c3b1c99696bfccd33eff63b08bd07788127b1a00b089c42c0e1afdb3b32f16"

  url "https://github.com/karansinghgit/speaktype/releases/download/v#{version}/SpeakType-#{version}.dmg",
      verified: "github.com/karansinghgit/speaktype/"
  name "SpeakType"
  desc "Open-source offline voice dictation app"
  homepage "https://tryspeaktype.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "speaktype.app"

  zap trash: "~/Library/Preferences/com.2048labs.speaktype.plist"
end
