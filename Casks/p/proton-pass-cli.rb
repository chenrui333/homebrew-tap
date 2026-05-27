cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.1.1"
  sha256 arm:          "787b107dbfb759502460cac361724e2862d5082025fc02e902f436a92df050a9",
         intel:        "a23b7781578d0220d655f745b40e89abf5b0a8cd3fa3537f2ec080c747abb8af",
         arm64_linux:  "d76579e5191ea4a56d8e254898c9c6c5242a7f3a3a5204dccb88f34409e4c9fb",
         x86_64_linux: "97eeed17907674cfde7b397157f14f3ae0d1391c82732062971f4b1333559a8f"

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
