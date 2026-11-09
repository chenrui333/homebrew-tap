cask "speaktype" do
  version "2.0.0"
  sha256 "34041fd61259669baae691255fdf1cb07ff3bf3d3ca5fec5a770ab705ca275f0"

  url "https://github.com/karansinghgit/speaktype/releases/download/v#{version}/SpeakType_#{version}_universal.dmg"
  name "SpeakType"
  desc "Open-source offline voice dictation app"
  homepage "https://tryspeaktype.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "SpeakType.app"

  zap trash: "~/Library/Preferences/com.2048labs.speaktype.plist"
end
