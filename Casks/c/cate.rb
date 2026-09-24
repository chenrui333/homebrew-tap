cask "cate" do
  arch arm: "-arm64"

  version "2.0.3"
  sha256 arm:   "98d9c06d2bada74851d0fff8e85c7f61314df62f73349f17a46fff1ea162f26d",
         intel: "be2198eb35d3935e07c5a990795ef7f9f449287be79fc0dc97b0687d6de57c70"

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
