cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.7.1"
  sha256 arm:          "0f5f749372c77f279f92463c56c3dda777fc3157e5f90ef49ade17bca7e46ba3",
         intel:        "ea3a6a133292230008e577ebcdf1a0a604177fd9107fdee287c8ed84ef164cd9",
         arm64_linux:  "43616b8c38b44dae702679b376726889a1f9dc767cf86932b29b03d89a93b283",
         x86_64_linux: "3e9520fe79ab4698e03905c8bf0fff4889b3028975e832a5f801a9c82008b612"

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
