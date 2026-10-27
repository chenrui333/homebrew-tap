cask "piebald" do
  version "0.8.0"
  sha256 "f66f6f7d3b0d0807d23d2affab076bfc16e3362c0f5d1f64bb0375c75fd51fbd"

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
