cask "piebald" do
  version "0.3.2"
  sha256 "1d643ee6798ed4f29bc9b4aff3068c5fb56ceda62f08feb55738fe347bda3da7"

  url "https://github.com/Piebald-AI/piebald-issues/releases/download/v#{version}/Piebald_#{version}_universal.dmg",
      verified: "github.com/Piebald-AI/piebald-issues/"
  name "Piebald"
  desc "Agentic AI control platform for orchestrating multiple AI agents"
  homepage "https://piebald.ai/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "Piebald.app"

  zap trash: [
    "~/Library/Application Support/ai.piebald.desktop",
    "~/Library/Application Support/piebald",
    "~/Library/Caches/ai.piebald.desktop",
  ]
end
