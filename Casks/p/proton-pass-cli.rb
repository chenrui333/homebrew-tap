cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.0.2"
  sha256 arm:          "0bfd99c4d8270ce2c2913c93a823c620a8975e3c2f1ce24d234e41706cb5cf47",
         intel:        "a975ca6af19177a2d274b7a8222c2510d84e13d252fd9c50bf8df67e54b42818",
         arm64_linux:  "c12c531adb823d4eae4f6e69065c6e767b10ed71328a1b3fa625a4897ae3b38c",
         x86_64_linux: "fd60a5041e642a7b1135ef6878c3d7ce3523b083210ea8100eee5c3701017ed9"

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
