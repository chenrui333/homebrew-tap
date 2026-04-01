cask "piebald" do
  version "0.2.1"
  sha256 "1195911653094d24b50112ab4172cf59526be0f25433be7704cfc14ac5405517"

  url "https://github.com/Piebald-AI/piebald-issues/releases/download/v#{version}/Piebald_#{version}_universal.dmg",
      verified: "github.com/Piebald-AI/piebald-issues/"
  name "Piebald"
  desc "Agentic AI control platform for orchestrating multiple AI agents"
  homepage "https://piebald.ai/"

  depends_on macos: ">= :monterey"

  app "Piebald.app"
end
