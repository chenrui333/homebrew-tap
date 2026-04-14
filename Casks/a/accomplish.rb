cask "accomplish" do
  arch arm: "arm64", intel: "x64"

  version "0.4.14"
  sha256 arm:   "b400f979844638e135a360d87cdd652d041fe87927e03b0c9bedb1ba7ebe31a9",
         intel: "85a09557b1ac2b652e687824b60f4a9c90d670a26eac966013af052fd6394631"

  url "https://downloads.accomplish.ai/downloads/#{version}/macos/Accomplish-#{version}-mac-#{arch}.dmg"
  name "Accomplish"
  desc "AI desktop agent that automates file management and browser tasks"
  homepage "https://www.accomplish.ai/"

  livecheck do
    url "https://www.accomplish.ai/"
    regex(/Accomplish[._-]v?(\d+(?:\.\d+)+)[._-]mac/i)
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Accomplish.app"

  zap trash: [
    "~/Library/Application Support/Accomplish",
    "~/Library/Preferences/ai.accomplish.desktop.plist",
  ]
end
