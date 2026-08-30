cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.2.2"
  sha256 arm:   "a9283796a0606e25b9f6407d9c9840ea1af4b4307433443b00d9dfc14c0fb46e",
         intel: "d18bed3afcadcc49bd3708fd61d8f8041129417828d31177e89e5b72eaa52263"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg",
      verified: "github.com/Auto-Explore/GitComet/"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: :ventura

  app "GitComet.app"
end
