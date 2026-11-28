cask "opencode-rune" do
  arch arm: "arm64", intel: "x64"

  version "0.0.0-dev-505"
  sha256 arm:   "5252dbed2214a2a70583bf35a485ed0eca2281f49af280e7fcff36bf03aaf18c",
         intel: "0f86c334283a8c6d8bbceeaca4751453add200c92242dbd1bd95f1f3b3ee2698"

  url "https://github.com/anomalyco/opencode-rune/releases/download/v#{version}/OpenCode-Rune-#{version}-macos-#{arch}.dmg"
  name "OpenCode (Rune)"
  desc "Rust-based desktop client for OpenCode"
  homepage "https://github.com/anomalyco/opencode-rune"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+-dev-\d+)$/i)
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura

  app "OpenCode (Rune).app"

  uninstall quit: "anomaly.opencode-rune"
end
