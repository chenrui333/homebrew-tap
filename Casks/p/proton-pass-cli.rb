cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.5.1"
  sha256 arm:          "2c5834dd21bef341db70c39eaa0a353d4b9e49a8a0d4e5579c02f62ed70db3d9",
         intel:        "fed0d6a919b8b05921c508cdd4cfe8c05a0b0cf4ccc55ed036e3b51ace6f7373",
         arm64_linux:  "03042c8ad70b21fa1da834f2e4e74484710ab3f05754af10c5035acdf68f3c87",
         x86_64_linux: "40e27645e0485f5f0db928b81469d1c5a7c8968a162956e940069476244c02b1"

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
