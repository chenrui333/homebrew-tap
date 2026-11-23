cask "dhictl" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.0.0"
  sha256 arm:          "03835a91322020f88f32e21b19e6062f18638a7dda79ccd8a7578acdbf250d72",
         intel:        "9b59f59dae8300831059500a0daf5175bb3c626211c3104ab41e59bc9df99b1f",
         arm64_linux:  "1ef2a32a1e43f4e631d9d372e27fd12f78defb8272d200ed188e542ccf12aa58",
         x86_64_linux: "112b5ef558896097aac4f769dc52f4b8764f1ca79f9c92d48aac9eaf15896948"

  url "https://github.com/docker-hardened-images/dhictl/releases/download/v#{version}/dhictl-#{os}-#{arch}"
  name "dhictl"
  desc "CLI tool for managing Docker Hardened Images (DHI)"
  homepage "https://github.com/docker-hardened-images/dhictl"

  binary "dhictl-#{os}-#{arch}", target: "dhictl"
  binary "dhictl-#{os}-#{arch}", target: "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins/docker-dhi"
  generate_completions_from_executable "dhictl", shell_parameter_format: :cobra

  zap :not_required

  caveats <<~EOS
    dhictl is installed as the Docker CLI plugin `docker-dhi` and invoked as `docker dhi`. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
      "cliPluginsExtraDirs": [
        "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
      ]
  EOS
end
