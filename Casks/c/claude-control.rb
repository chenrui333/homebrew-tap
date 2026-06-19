cask "claude-control" do
  arch arm: "-arm64", intel: ""

  version "0.17.0"
  sha256 arm:   "16d0b70ba7402c7ad793399d1d79a9bb4e280c1e5c946fb938537cf7e89b50d4",
         intel: "fb2aa86213b3680b1146017ef8ce54861fe9b6bf8fc0eb431c317ebc9a63cd20"

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
