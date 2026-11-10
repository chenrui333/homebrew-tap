cask "multica-app" do
  arch arm: "arm64", intel: "x64"

  version "0.8.2"
  sha256 arm:   "9f9cb92aa97588d8dfb7e63f515c702717e7eddc86937cb1f06f06c813667253",
         intel: "78e936092feacb3db08236061251335338754ef43e532942007bc6955ee595bc"

  url "https://github.com/multica-ai/multica/releases/download/v#{version}/multica-desktop-#{version}-mac-#{arch}.zip"
  name "Multica"
  desc "Desktop client for the Multica coding agent platform"
  homepage "https://github.com/multica-ai/multica"

  depends_on macos: :ventura

  app "Multica.app"

  uninstall quit: "ai.multica.desktop"
end
