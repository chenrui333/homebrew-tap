cask "piebald" do
  version "0.5.2"
  sha256 "6a546c50a85c34940770a026c19dbf2935fd7f58689910322ca4e781a457c7ef"

  url "https://github.com/Piebald-AI/piebald-issues/releases/download/v#{version}/Piebald_#{version}_universal.dmg",
      verified: "github.com/Piebald-AI/piebald-issues/"
  name "Piebald"
  desc "Agentic AI control platform for orchestrating multiple AI agents"
  homepage "https://piebald.ai/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "Piebald.app"

  zap trash: [
    "~/Library/Application Support/ai.piebald.desktop",
    "~/Library/Application Support/piebald",
    "~/Library/Caches/ai.piebald.desktop",
  ]
end
