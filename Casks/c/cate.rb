cask "cate" do
  arch arm: "-arm64"

  version "2.0.5"
  sha256 arm:   "a624da0fb2739a12386038d3f19fd563d461d4fad9e9e2239e97e63976144740",
         intel: "277ed4e69af5050c6e13c8db642b429aafc5bc85ca8984c3f75ed25794f8e43e"

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
