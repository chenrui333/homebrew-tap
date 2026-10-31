cask "multica" do
  arch arm: "arm64", intel: "x64"

  version "0.7.2"
  sha256 arm:   "90f627a8505489f1fa136ef3f0b0204361d114d875eba33a4835872b87a83675",
         intel: "da7622062a9639f893d3bf2862940c93402a8bd674ad43052f55b79e7454caa6"

  url "https://github.com/multica-ai/multica/releases/download/v#{version}/multica-desktop-#{version}-mac-#{arch}.zip"
  name "Multica"
  desc "Desktop client for the Multica coding agent platform"
  homepage "https://github.com/multica-ai/multica"

  depends_on macos: :ventura

  app "Multica.app"

  uninstall quit: "ai.multica.desktop"
end
