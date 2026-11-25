cask "multica-app" do
  arch arm: "arm64", intel: "x64"

  version "0.13.0"
  sha256 arm:   "59e4869e471250d4f235afb96cf24383969427b99cec738b795b25fc00d64de0",
         intel: "26d6361bd62528099322528e76ee365133d1717d1d511e63ce7fe8b9e04228d2"

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
