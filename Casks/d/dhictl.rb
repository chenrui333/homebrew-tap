cask "dhictl" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "0.0.10"
  sha256 arm:          "4ea3fc1b681756b9855782cfc490b34aeb59df06a5806923f45c00356c95ecb3",
         intel:        "7c8f5b94c8135cc56d26aaeb7d4b62d73c60a1186939f3ee9b03579b200caa85",
         arm64_linux:  "6b38ffd4989281e874b86b851eca8cea7b07886b4a8f66717d978cac83db2c07",
         x86_64_linux: "f823967317ef13f20b0bfbb17d112b5a89a7cbada3a7bbc7c7acc8cbd59edfc3"

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
