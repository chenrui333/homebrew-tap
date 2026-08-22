cask "agent-sessions" do
  version "5.0.2"
  sha256 "89f794f069b3f65319588f57be71761bc7a925ddc207334312ddd867c0b065ab"

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
