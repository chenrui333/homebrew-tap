cask "multica-app" do
  arch arm: "arm64", intel: "x64"

  version "0.8.1"
  sha256 arm:   "2f193c73ea6af2a9c71e01ddd241250cd49fed560eeee2c924018dcaceabcc0b",
         intel: "9db61a9bf0b79742341840cf6ef376ae5b38ff8c0e152a20a52d5e2afbe88f9a"

  url "https://github.com/multica-ai/multica/releases/download/v#{version}/multica-desktop-#{version}-mac-#{arch}.zip"
  name "Multica"
  desc "Desktop client for the Multica coding agent platform"
  homepage "https://github.com/multica-ai/multica"

  depends_on macos: :ventura

  app "Multica.app"

  uninstall quit: "ai.multica.desktop"
end
