cask "dhictl" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "0.0.7"
  sha256 arm:          "4f23c7b2fb11817403ecd1c32a83adb868f352f94a6a493bea7fae54177624d5",
         intel:        "97d4d0dab8d2050463c5301a1571ef7105b6d5875e44b3e7f9ddc87d2a4d6573",
         arm64_linux:  "2e1093ab4822317d36e6120def8794c5977dfc76b22534810af3d73e7153d2cb",
         x86_64_linux: "0652b8cce9152587affe030526a8aa54de6989f16ce033535da65e7420551f40"

  url "https://github.com/docker-hardened-images/dhictl/releases/download/v#{version}/dhictl-#{os}-#{arch}"
  name "dhictl"
  desc "CLI tool for managing Docker Hardened Images (DHI)"
  homepage "https://github.com/docker-hardened-images/dhictl"

  binary "dhictl-#{os}-#{arch}", target: "dhictl"

  # No zap stanza required
end
