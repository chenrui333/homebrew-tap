cask "exort" do
  arch arm: "arm64", intel: "x64"

  version "0.4.1"
  sha256 arm:   "db5b6def5580726043bec42756b0a7de6b039d0937ac15e4e77c3998c1ea5726",
         intel: "29ac864371f2fb0b0c112446f8c2b89aeba2e6d37f04bdc2634477aff5920d1b"

  url "https://github.com/Razz19/Exort/releases/download/v#{version}/Exort-#{version}-mac-#{arch}.dmg"
  name "Exort"
  desc "Coding agent for embedded devices"
  homepage "https://github.com/Razz19/Exort"

  depends_on :macos

  app "Exort.app"

  zap trash: [
    "~/Library/Application Support/Exort",
    "~/Library/Caches/Exort",
    "~/Library/Preferences/com.exort.app.plist",
  ]
end
