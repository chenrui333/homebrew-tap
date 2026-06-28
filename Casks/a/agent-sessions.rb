cask "agent-sessions" do
  version "4.0"
  sha256 "9cb76f36d8845875a37a2f0528e090df2d0cfde1f8e9d4018f51d5490e85dd0a"

  url "https://github.com/jazzyalex/agent-sessions/releases/download/v#{version}/AgentSessions-#{version}.dmg"
  name "AgentSessions"
  desc "Session browser, analytics, and rate-limit tracker for AI coding agents"
  homepage "https://github.com/jazzyalex/agent-sessions"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura

  app "AgentSessions.app"

  zap trash: [
    "~/Library/Application Support/AgentSessions",
    "~/Library/Preferences/com.jazzyalex.AgentSessions.plist",
  ]
end
