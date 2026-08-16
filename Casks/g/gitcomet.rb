cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.2.0"
  sha256 arm:   "b524623ddbbe2093f97ac7cda7b88f6260e8b28bccd2601312cc40335fb09060",
         intel: "011b648de763b8ef1c1193810339d6704c2c035c3d8e4bb60a38831eeb307cd4"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/Auto-Explore/GitComet/"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: :ventura

  app "GitComet.app"
end
