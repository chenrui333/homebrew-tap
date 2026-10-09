cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.3.0"
  sha256 arm:   "53dcf84fdc388c4ada69abae58c76dddf8e0f18f032195085b4b6b917b9de583",
         intel: "4daad18eb43dcde504baedefd1224d972555656c27a3adff9f181371394f5b51"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: :ventura

  app "GitComet.app"
end
