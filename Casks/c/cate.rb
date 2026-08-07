cask "cate" do
  arch arm: "-arm64"

  version "1.6.0"
  sha256 arm:   "53717f71bca5a06138b8fd805372bb4151f6883021ef9ece49e1ced1264fa063",
         intel: "218f0050301bfdde643e14580cc2eeff226d5006ac443497d0ec2d7ab5e1e39e"

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
