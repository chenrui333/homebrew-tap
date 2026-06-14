cask "cate" do
  arch arm: "-arm64", intel: ""

  version "1.3.0"
  sha256 arm:   "586dc6729b4f3657a2781a5195a57bc83e265047811449f287ae9c2051522ac9",
         intel: "0beb0406c59e34632a32063b84be470fdbf6be691b002c6775912f810bcaae42"

  url "https://github.com/0-AI-UG/cate/releases/download/v#{version}/Cate-#{version}#{arch}.dmg",
      verified: "github.com/0-AI-UG/cate/"
  name "Cate"
  desc "Canvas Terminal Editor"
  homepage "https://cate.cero-ai.com/"

  depends_on macos: :monterey

  app "Cate.app"

  zap trash: [
    "~/Library/Application Support/Cate",
    "~/Library/Caches/Cate",
    "~/Library/Preferences/com.cero-ai.cate.plist",
  ]
end
