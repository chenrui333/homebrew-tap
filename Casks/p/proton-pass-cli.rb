cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.7.0"
  sha256 arm:          "f17222619b4c4c4112eccc3796edea4bc0e4a341dc8960f7bb4023782adcc4a1",
         intel:        "1829f7ecef108df5e14f92081cf4a4412c0fdc5be2034f9ee85d1e6745a62322",
         arm64_linux:  "93918d5621593cac88956854d0f52cbc43851dcd9c01840ffe48a88b3be84c6b",
         x86_64_linux: "fd933e76179a5a33b295853e9c6696e49e584fe2141b1aafc63a3d78c0791cdb"

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
