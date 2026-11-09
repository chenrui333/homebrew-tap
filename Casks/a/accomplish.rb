cask "accomplish" do
  arch arm: "arm64", intel: "x64"

  version "0.4.14"
  sha256 arm:   "c77fd16e4c302fda89fc258cc502cacdde2a8e9385de741b9041b05af2cabbe0",
         intel: "335a75d27bdd8265aebd2ee9d93400262cad2d0eb9ba539b4c5183020d39b1a5"

  url "https://downloads.accomplish.ai/downloads/#{version}/macos/Accomplish-#{version}-mac-#{arch}.zip"
  name "Accomplish"
  desc "AI desktop agent that automates file management and browser tasks"
  homepage "https://www.accomplish.ai/"

  deprecate! date: "2026-11-08", because: :discontinued

  auto_updates true
  depends_on :macos

  app "Accomplish.app"

  zap trash: [
    "~/Library/Application Support/Accomplish",
    "~/Library/Preferences/ai.accomplish.desktop.plist",
  ]
end
