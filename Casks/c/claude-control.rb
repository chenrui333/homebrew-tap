cask "claude-control" do
  arch arm: "-arm64"

  version "0.18.0"
  sha256 arm:   "8b630ff6a38aa4e2a804523220457154376748bc7a7fc7099cc8a7a414ad97fb",
         intel: "b8188728d56dc87dfb1f22a3706b36e2cc220bf2408420e66b7279ed0453c40a"

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
