cask "agent-sessions" do
  version "5.5.2"
  sha256 "52f40cef0b0c361755b8760de309974610ff9b31879fa2386d018b8a141b882f"

  url "https://github.com/jazzyalex/agent-sessions/releases/download/v#{version}/AgentSessions-#{version}.dmg"
  name "AgentSessions"
  desc "Session browser, analytics, and rate-limit tracker for AI coding agents"
  homepage "https://github.com/jazzyalex/agent-sessions"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sonoma

  app "AgentSessions.app"

  zap trash: [
    "~/Library/Application Support/AgentSessions",
    "~/Library/Preferences/com.jazzyalex.AgentSessions.plist",
  ]
end
