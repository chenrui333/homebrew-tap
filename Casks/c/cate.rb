cask "cate" do
  arch arm: "-arm64", intel: ""

  version "1.5.1"
  sha256 arm:   "2d939c5cc876e5f2f7ecd59927a5eaeed8c9e809800740e6fc60275ec3b1adee",
         intel: "90ccc98ce401c9963447534a4fd26223ccc679a2e2ed1c15d4d298d63b7b01fd"

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
