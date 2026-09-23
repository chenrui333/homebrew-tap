cask "piebald" do
  version "0.7.1"
  sha256 "cd71032a3f2e529f2fdcb6f118ca95fc5add8d29508ec947bc180e30b2734fcf"

  url "https://github.com/Piebald-AI/piebald-issues/releases/download/v#{version}/Piebald_#{version}_universal.dmg"
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
