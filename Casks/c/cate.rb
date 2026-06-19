cask "cate" do
  arch arm: "-arm64", intel: ""

  version "1.3.1"
  sha256 arm:   "95d16b461fb51bbef41d523aa34b3ef16d38cc7cdf73b67090a102ae1a14ea7a",
         intel: "40d1f419516e03005b483361259281398916d53b8fc5db72813275c49c1de974"

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
