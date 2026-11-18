cask "multica-app" do
  arch arm: "arm64", intel: "x64"

  version "0.11.0"
  sha256 arm:   "98d7eda362459c2838aad014c96931fc3b6b42352d32295549f8808e6a2e51cc",
         intel: "7eef27a36b493129a3866968911cf0e00c01402e0327df5aa8b82ad98cc40eea"

  url "https://github.com/multica-ai/multica/releases/download/v#{version}/multica-desktop-#{version}-mac-#{arch}.zip"
  name "Multica"
  desc "Desktop client for the Multica coding agent platform"
  homepage "https://github.com/multica-ai/multica"

  depends_on macos: :ventura

  app "Multica.app"

  uninstall quit: "ai.multica.desktop"
end
