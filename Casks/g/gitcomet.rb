cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.1.12"
  sha256 arm:   "56ba0333b3d5d5344f938ebdcf7d2f84803569c93c14d00752b454bc0ec2a5d8",
         intel: "22e07c71e27d78f90d6398d3ed86625168ed9d4a0569bc8a28e3a87251456b60"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/Auto-Explore/GitComet/"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: ">= :ventura"

  app "GitComet.app"
end
