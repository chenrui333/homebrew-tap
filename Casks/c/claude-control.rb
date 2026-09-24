cask "claude-control" do
  arch arm: "-arm64"

  version "0.19.0"
  sha256 arm:   "266b8c7c28486d99179401ce869e1a39c46c7d47bb949ea6e1835c58f0cb2e0f",
         intel: "4c96a39a4c7107d2bc58f4a8200bb66381413fec114aed9e53fa15a8fdcb7f65"

  url "https://github.com/sverrirsig/claude-control/releases/download/v#{version}/Claude.Control-#{version}#{arch}.dmg"
  name "Claude Control"
  desc "Desktop dashboard for monitoring and managing Claude Code sessions"
  homepage "https://github.com/sverrirsig/claude-control"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :monterey

  app "Claude Control.app"
end
