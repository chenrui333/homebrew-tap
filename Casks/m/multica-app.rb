cask "multica-app" do
  arch arm: "arm64", intel: "x64"

  version "0.9.0"
  sha256 arm:   "73072241392375532e37fffb1a613032742dbc5a36ba0eeec830c25cee9401bd",
         intel: "0fc6ad882366ddc56b09c4e47b836abe17aabc769d5004e8a958fc3609a30662"

  url "https://github.com/multica-ai/multica/releases/download/v#{version}/multica-desktop-#{version}-mac-#{arch}.zip"
  name "Multica"
  desc "Desktop client for the Multica coding agent platform"
  homepage "https://github.com/multica-ai/multica"

  depends_on macos: :ventura

  app "Multica.app"

  uninstall quit: "ai.multica.desktop"
end
