cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.1.4"
  sha256 arm:          "8b579bf452c346da57349a5e72c3839c466e064179b9383f481eefbfa8a65a44",
         intel:        "ee0f41d3a1c26022e3f99aff6f2280ec3e0f0e1c443c2c58652c26d3456dc235",
         arm64_linux:  "60d54456726378d80917de0e05d2e102697ee043b7e420a34d55c8437ced89f2",
         x86_64_linux: "8d637ac743c6ed39447d56c9cb28a3a15faec21bffcabe44c211bc3e4feab460"

  url "https://proton.me/download/pass-cli/#{version}/pass-cli-#{os}-#{arch}",
      verified: "proton.me/"
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
