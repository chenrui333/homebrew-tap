cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.4.2"
  sha256 arm:          "99e862094fd2a4f82788c9000ba5a92246e7739f86c35a84655b9d7e2adf7227",
         intel:        "44f7cd45bdfabe34079e6d6ba2ff54e3a3e9e3150046b6cbee326cad52edff18",
         arm64_linux:  "eee38fc4549a5dfcbb794aafcb6d517c9e0cd0dc3c53bbb2997fd8142ed681c7",
         x86_64_linux: "4089bdf5981140ac5bee65d2d79bf98767537f54d33197b79e5f86c630714842"

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
