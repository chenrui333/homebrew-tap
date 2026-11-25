cask "multica-app" do
  arch arm: "arm64", intel: "x64"

  version "0.12.1"
  sha256 arm:   "dade7b84a7e8db5277d1e12a811717780a401c3269a59f9f610ec6aa8e57f050",
         intel: "1e2e1f939ea7794df04f682678d12d52e5978ad23bdd1ca3d73c79f1722e2b0a"

  url "https://github.com/multica-ai/multica/releases/download/v#{version}/multica-desktop-#{version}-mac-#{arch}.zip"
  name "Multica"
  desc "Desktop client for the Multica coding agent platform"
  homepage "https://github.com/multica-ai/multica"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "Multica.app"

  uninstall quit: "ai.multica.desktop"
end
