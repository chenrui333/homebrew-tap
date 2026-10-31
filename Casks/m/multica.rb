cask "multica" do
  arch arm: "arm64", intel: "x64"

  version "0.7.2"
  sha256 arm:   "9cd35de7879598c457f78b484bf43e8232533b90422a16cf26a7e51beae13876",
         intel: "c9c3ac31322da9e0eec4b188176805c42c2a2a5f7c63080e96295005cb19fdb1"

  url "https://github.com/multica-ai/multica/releases/download/v#{version}/multica-desktop-#{version}-mac-#{arch}.dmg"
  name "Multica"
  desc "Desktop client for the Multica coding agent platform"
  homepage "https://github.com/multica-ai/multica"

  depends_on macos: :ventura

  app "Multica.app"

  uninstall quit: "ai.multica.desktop"
end
