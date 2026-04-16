cask "claude-control" do
  arch arm: "-arm64", intel: ""

  version "0.15.0"
  sha256 arm:   "89eee829b19ebbaf842c06114aa83abf1fd3a16756132cd0aac6eb20b6f3c57e",
         intel: "b9e723a534b1ba1eb085f8b6b2b547348f912e7c9d498f0298e1ccc927b33577"

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
