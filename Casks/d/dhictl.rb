cask "dhictl" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "0.0.6"
  sha256 arm:          "8659bec41c9bb25122370e0e570bebdb61df6d76f9690938cae9a5f09539c26b",
         intel:        "75dcb9ea72daa5225e05eba6bb90d574ef3e2f267067ddc027d6e3b9e3ecabd6",
         arm64_linux:  "10156fa90c1db17356e219cdcbd9bacdf6cf8f446f2e672efc3761110cedf9d7",
         x86_64_linux: "38e7f6d0f12f6c8b733ac8d2db392f670ebf75ee65618bf49abec49500d61940"

  url "https://github.com/docker-hardened-images/dhictl/releases/download/v#{version}/dhictl-#{os}-#{arch}"
  name "dhictl"
  desc "CLI tool for managing Docker Hardened Images (DHI)"
  homepage "https://github.com/docker-hardened-images/dhictl"

  binary "dhictl-#{os}-#{arch}", target: "dhictl"

  # No zap stanza required
end
