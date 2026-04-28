cask "speaktype" do
  version "1.0.21"
  sha256 "e2710780c9621a8111ee46cb58b14b5e73fcd750849c7ee3e9a3fbcb9f75fd79"

  url "https://github.com/karansinghgit/speaktype/releases/download/v#{version}/SpeakType-#{version}.dmg",
      verified: "github.com/karansinghgit/speaktype/"
  name "SpeakType"
  desc "Open-source offline voice dictation app"
  homepage "https://tryspeaktype.com/"

  depends_on macos: ">= :sonoma"

  app "SpeakType.app"
end
