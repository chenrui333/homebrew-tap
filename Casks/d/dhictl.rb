cask "dhictl" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "0.0.5"
  sha256 arm:          "460ec15d863188105de9e487b7905900d4d05d568609f52a7d67ce1e05f09b84",
         intel:        "63fd1c9a4d15ee7e66a762f3bfec68775f875304555d78dff8ec8a764ceb1a5d",
         arm64_linux:  "6cd76ef527f3f85fa3b27a0f60a602339cfa5d91b8b018174e9ca6a6615b638f",
         x86_64_linux: "4f6da1177c6e4a8e41e25446bff53d04dd38dba8080ae7b6d5766569d1d4263c"

  url "https://github.com/docker-hardened-images/dhictl/releases/download/v#{version}/dhictl-#{os}-#{arch}"
  name "dhictl"
  desc "CLI tool for managing Docker Hardened Images (DHI)"
  homepage "https://github.com/docker-hardened-images/dhictl"

  binary "dhictl-#{os}-#{arch}", target: "dhictl"

  # No zap stanza required
end
