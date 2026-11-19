cask "multica-app" do
  arch arm: "arm64", intel: "x64"

  version "0.11.1"
  sha256 arm:   "a9962c5cc8fab0dc5121ae61da338c3918ac3ae91cf24874e73e247b440ebe11",
         intel: "0282d18d85217aa5564a1bc325306aed51629f96eee7bf02e794bf9d578b0534"

  url "https://github.com/multica-ai/multica/releases/download/v#{version}/multica-desktop-#{version}-mac-#{arch}.zip"
  name "Multica"
  desc "Desktop client for the Multica coding agent platform"
  homepage "https://github.com/multica-ai/multica"

  depends_on macos: :ventura

  app "Multica.app"

  uninstall quit: "ai.multica.desktop"
end
