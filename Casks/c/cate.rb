cask "cate" do
  arch arm: "-arm64", intel: ""

  version "1.3.2"
  sha256 arm:   "d759ee654f42a301d52b58e3afaf1e77e6b1df76b9c7d53b337f75ba5cacfee5",
         intel: "07f0c2e5f01d60a885edf86616876a36e1dc3c7f8f4a248414a2751fabbd1dfc"

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
