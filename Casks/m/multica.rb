cask "multica" do
  arch arm: "arm64", intel: "x64"

  version "0.8.0"
  sha256 arm:   "a51b2381e1fea2599e99e4fadcf5581dae067e3b09d89a696d11bd4e735981e1",
         intel: "d6e9c72171c477ebfc745cb4608d2086ec74995dd207089d809868963a2dd414"

  url "https://github.com/multica-ai/multica/releases/download/v#{version}/multica-desktop-#{version}-mac-#{arch}.zip"
  name "Multica"
  desc "Desktop client for the Multica coding agent platform"
  homepage "https://github.com/multica-ai/multica"

  depends_on macos: :ventura

  app "Multica.app"

  uninstall quit: "ai.multica.desktop"
end
