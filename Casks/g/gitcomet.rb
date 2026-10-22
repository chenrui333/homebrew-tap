cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.3.2"
  sha256 arm:   "77d7c2d8fcc0f9c4e64ba44e0144f4d233c0be77b1e110837ad12a44db1ed86b",
         intel: "8eecf0f570be356224ff67cadae7efb08effc538b99c3bc495a7fe160d79742c"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: :ventura

  app "GitComet.app"
end
