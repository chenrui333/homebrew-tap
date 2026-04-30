cask "claude-control" do
  arch arm: "-arm64", intel: ""

  version "0.16.0"
  sha256 arm:   "dfecffe1ec54abdebe5e04db89106529bedfdcfd7591d88996253e6081012dce",
         intel: "1d11ee0465ef1fce6472711fc581346959f35c9949bf8e89fff5fb55babd29ef"

  url "https://github.com/sverrirsig/claude-control/releases/download/v#{version}/Claude.Control-#{version}#{arch}.dmg"
  name "Claude Control"
  desc "Desktop dashboard for monitoring and managing Claude Code sessions"
  homepage "https://github.com/sverrirsig/claude-control"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Claude Control.app"
end
