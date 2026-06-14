cask "exort" do
  arch arm: "arm64", intel: "x64"

  version "0.4.0"
  sha256 arm:   "d471188a14477aa4d3eb8c75c3688557ac1941e13781d572bfd5746b283c6818",
         intel: "76bd0aa00c562964a34c05e3f2772b65c83dcbc0a97dff3748e314dd1ec32cf8"

  url "https://github.com/Razz19/Exort/releases/download/v#{version}/Exort-#{version}-mac-#{arch}.dmg"
  name "Exort"
  desc "Coding agent for embedded devices"
  homepage "https://github.com/Razz19/Exort"

  depends_on macos: :big_sur

  app "Exort.app"

  zap trash: [
    "~/Library/Application Support/Exort",
    "~/Library/Caches/Exort",
    "~/Library/Preferences/com.exort.app.plist",
  ]
end
