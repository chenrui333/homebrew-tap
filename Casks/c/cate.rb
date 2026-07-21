cask "cate" do
  arch arm: "-arm64", intel: ""

  version "1.5.2"
  sha256 arm:   "a2695c8bee890d064c857492316416efb200b93106127f77867b3198c608198b",
         intel: "6eaa3ea7efd082f0ed173ae09d1a3234b4116dc99ecf87ba7e38d0a4ea034ac8"

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
