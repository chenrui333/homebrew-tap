cask "multica-app" do
  arch arm: "arm64", intel: "x64"

  version "0.10.0"
  sha256 arm:   "3710a9292a779150d9692c7543146f687c9e6601ba776b55d1e245fa5247b0e3",
         intel: "12601e2e65c4ca92c6fb95f88aab1bbf9c3e0d8bda04a7ce8407865bbf5c7f4b"

  url "https://github.com/multica-ai/multica/releases/download/v#{version}/multica-desktop-#{version}-mac-#{arch}.zip"
  name "Multica"
  desc "Desktop client for the Multica coding agent platform"
  homepage "https://github.com/multica-ai/multica"

  depends_on macos: :ventura

  app "Multica.app"

  uninstall quit: "ai.multica.desktop"
end
