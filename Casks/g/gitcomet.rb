cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.3.1"
  sha256 arm:   "5c2decb3b54ed37841713607b4bdd479acdf19f8b2f43a94892d5cfafa23175e",
         intel: "0baf6beabd81393d3a7e3738460809e910b9a00b8c87a68501e3becd2d47f186"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: :ventura

  app "GitComet.app"
end
