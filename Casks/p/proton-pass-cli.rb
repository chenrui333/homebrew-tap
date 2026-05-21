cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.1.0"
  sha256 arm:          "e4541297a5ea8a99ba316ab69336b61555d26a35f8c4207882a68079de343682",
         intel:        "893e77702b24498f3e02f2d759019ca859254092413b577b005304218103965a",
         arm64_linux:  "e1481c47dc95fe241a42841414345afb2cd208520893f49a3c23897538293102",
         x86_64_linux: "5a775d5f83affbd8c1bcbf1517c38d1a157c160133e7136b00d5311bafe8ba93"

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
