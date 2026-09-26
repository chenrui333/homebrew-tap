cask "cate" do
  arch arm: "-arm64"

  version "2.0.4"
  sha256 arm:   "e50c754debfd4b057fa0e1c7b63d46de92e5aa37a0c56d4404d3888038d77212",
         intel: "080c0317ce0bd5e702aaef97be819aad2c17946296734f93d2b50e760de816d5"

  url "https://github.com/0-AI-UG/cate/releases/download/v#{version}/Cate-#{version}#{arch}.dmg"
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
