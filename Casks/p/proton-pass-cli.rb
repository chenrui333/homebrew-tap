cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.0.0"
  sha256 arm:          "0adc796478e5c40bb8c6efa3a38a1bca65ff1a6afe3bf827878380b652a36996",
         intel:        "b4eb9381d1fc5e2fcc3257db9a8b11499458a0d0534565aaa1fa6084f74cceba",
         arm64_linux:  "59eeeaa9acddb7a7f6242473e2e7e43da470ccae0c6c9701cf9ffa7d3e2400a5",
         x86_64_linux: "7dc49f969682ec6508e2e9db510d54fc61b4c183076abdaa0e97232f8d0b3326"

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
