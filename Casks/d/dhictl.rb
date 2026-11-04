cask "dhictl" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "0.0.13"
  sha256 arm:          "1c98a642cafe700f78eb41ecb67436069cb6a4d88cd7ce763d444e2be2305fb5",
         intel:        "5ebe190a2cfcfe1e532dfb9a8df05d8daa14d23f30ab65bfcef7d42171c7f97c",
         arm64_linux:  "31a2deb4019b1719fe72dafc3358da0c91514a4e4e10237b146fbb87f4ebabce",
         x86_64_linux: "50e5e5904ac24484da44070bd7607c10901b5fcbea39521abe0f5c9538c849c4"

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
