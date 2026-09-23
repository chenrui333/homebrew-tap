cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.2.5"
  sha256 arm:   "8e6b46b641c5206c233534c723ddc6e127673b64a86654ac0f635d072e8a3255",
         intel: "7205148bf1a8ca3f93a4ee4c348714b727522a73ccf747fce4847642c310e98b"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: :ventura

  app "GitComet.app"
end
