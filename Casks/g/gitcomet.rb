cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.1.15"
  sha256 arm:   "c4c1b1fcb316194fd19288f7c41a9426c599d8b2c3b4b4be8491dc75df372e01",
         intel: "9a649d0ae089db8eab283c5607b486509472d2324545005d827a9365dcf60c50"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/Auto-Explore/GitComet/"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: :ventura

  app "GitComet.app"
end
