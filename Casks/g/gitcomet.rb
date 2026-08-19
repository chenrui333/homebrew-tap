cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.2.1"
  sha256 arm:   "554edc245f47717a1656d1b1c7e5352d6666fdcd3038b158997055469ed880ab",
         intel: "f45a0eff9250e062bad8260ebb13286d329062e12d2999069e2068047d624197"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/Auto-Explore/GitComet/"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: :ventura

  app "GitComet.app"
end
