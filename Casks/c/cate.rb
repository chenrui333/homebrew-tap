cask "cate" do
  arch arm: "-arm64", intel: ""

  version "1.5.3"
  sha256 arm:   "b6d756e7347c40b613428fde60adb20744be2f4a4456240c9cd54df1b09d81b5",
         intel: "5d20f8b740f33a3f205225d9c053e5ccde66cfd85a246f133add46f24a243511"

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
