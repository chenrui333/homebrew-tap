cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.1.16"
  sha256 arm:   "2cd4049ea4a8efc0e6f2ff97c9fbb480496b08f8db44de4be75fde1a26b0e822",
         intel: "3d0b67aabcf61e866215b5214f5ae98d0bf6cb2a65101034083705cd26d63bba"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/Auto-Explore/GitComet/"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: :ventura

  app "GitComet.app"
end
