cask "agent-sessions" do
  version "4.2"
  sha256 "95df22696d3be50a3bd16232f80bbbc305421ab7c87f0b5f33955b18c8f016dc"

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
