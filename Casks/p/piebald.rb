cask "piebald" do
  version "0.4.4"
  sha256 "ced23a05e3b6a2e328da38d698578336d5d9f6f155b49909e525ca60a60bf4d2"

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
