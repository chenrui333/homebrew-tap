cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.2.6"
  sha256 arm:   "6321da7ea5f04d9f366afc6be7937608b79a54f6467e5a1e85abd8458759e4c9",
         intel: "b7d87c334c4aa149c93e2189c76fe577b42c5ae40597c0767fc8494b92620875"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: :ventura

  app "GitComet.app"
end
