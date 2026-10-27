cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.6.0"
  sha256 arm:          "004efc4dbc30cbcd8b85506b24687b4cfdc75c9b412b2efb9efce685f09e42e3",
         intel:        "2a36d1923be5257ddc0efc3383b78362b1cb612595da49ee92fcfd9aa0c02823",
         arm64_linux:  "0196958267711b25f1335b70428fb07e0d8d3be61a028ace879d74cb6586bac7",
         x86_64_linux: "36e5657688297cff66f66eef1db28528013be5387fecad2200a5cd4a904cb781"

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
