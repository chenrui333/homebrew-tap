cask "agent-sessions" do
  version "3.9.3"
  sha256 "c19e9f7f40ba53d9590f6a0a0c8a69f1889a962454007622ceb4d2d606679656"

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
