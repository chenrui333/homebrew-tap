cask "gitcomet" do
  arch arm: "arm64", intel: "x86_64"

  version "0.3.3"
  sha256 arm:   "ffde019181122d599ff84cc4cd51f24d066e3123ccc3386ae2dcd4f8e259e5ba",
         intel: "ef2f0affd87de80ad2348bb442d5066a857e19edaf0126471e6c81f60c5a0701"

  url "https://github.com/Auto-Explore/GitComet/releases/download/v#{version}/gitcomet-v#{version}-macos-#{arch}.dmg"
  name "GitComet"
  desc "Open-source user interface for Git workflows"
  homepage "https://gitcomet.dev/"

  depends_on macos: :ventura

  app "GitComet.app"
end
