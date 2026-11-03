cask "exort" do
  arch arm: "arm64", intel: "x64"

  version "0.4.2"
  sha256 arm:   "036173154295eda2a4720b180a217b7dbeacab76427b23101c91f59c92ecd1e8",
         intel: "4e44e58a5ea83535b3085895a01da69e8212d4c9fab8bc682a3abdc08e696666"

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
