cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.1.7"
  sha256 arm:   "a5b0d1547c30b404b50c9c54951c4089d724b2eb9dffe9263f19e4f7fa4e39cf",
         intel: "0bea73d4182b0ca0bf6419a340078bca7ea9652175d21a43ffdbc82eff30b12d"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/Auto-Explore/GitComet/"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: ">= :ventura"

  app "GitComet.app"
end
