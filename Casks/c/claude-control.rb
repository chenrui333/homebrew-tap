cask "claude-control" do
  arch arm: "-arm64", intel: ""

  version "0.14.0"
  sha256 arm:   "a47045de15614778741335fd2bf000e26d8e40c7728a655a5aa3981d11474a35",
         intel: "3f133fb4edf8bb1065b902fc57049f7edf9c5bd724dd11890526098d814180db"

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
