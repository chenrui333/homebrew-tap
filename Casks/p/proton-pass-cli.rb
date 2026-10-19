cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.5.0"
  sha256 arm:          "8d99e78f6f2e470df7d972c981dbe6da9b2d322c093cf9d3048e54521e9ed70a",
         intel:        "d83e13609286cc6f648d621b9920b25f44b1c757a7c26075eb958c30cc21485c",
         arm64_linux:  "052f131d8d071d36097fea084c7e5823358ad0ad8ab41195e6348fc10ec8192c",
         x86_64_linux: "9ce925d06407097337a01502f281d63a8bed80b7c54b96942dd665d4eb488cfd"

  url "https://proton.me/download/pass-cli/#{version}/pass-cli-#{os}-#{arch}"
  name "Proton Pass CLI"
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"

  livecheck do
    url "https://proton.me/download/pass-cli/versions.json"
    strategy :json do |json|
      json["passCliVersions"]["version"]
    end
  end

  binary "pass-cli-#{os}-#{arch}", target: "pass-cli"

  zap trash: [
    "~/.local/share/proton-pass-cli",
    "~/.ssh/proton-pass-agent.*",
    "~/Library/Application Support/proton-pass-cli",
  ]
end
