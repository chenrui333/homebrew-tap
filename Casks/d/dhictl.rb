cask "dhictl" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "0.0.9"
  sha256 arm:          "2d72c897da0d2ed042ce4aef5458cae0da7db13be74728755ad1f22a5ac0a400",
         intel:        "ee69309d3a78b7db8faa5199250184c791633b3e2b90f3fab45ad1d877331ad7",
         arm64_linux:  "f75d6a82b46648728f2187bb4927eaecec8d9a704653f26a0a6bc4435b8b8be6",
         x86_64_linux: "6b3b8b543023a9edc2d641c4e11f4a5d758ea78f9f925bfde9b80df098b18e0b"

  url "https://github.com/docker-hardened-images/dhictl/releases/download/v#{version}/dhictl-#{os}-#{arch}"
  name "dhictl"
  desc "CLI tool for managing Docker Hardened Images (DHI)"
  homepage "https://github.com/docker-hardened-images/dhictl"

  binary "dhictl-#{os}-#{arch}", target: "dhictl"
  binary "dhictl-#{os}-#{arch}", target: "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins/docker-dhi"
  generate_completions_from_executable "dhictl", shell_parameter_format: :cobra

  # No zap stanza required

  caveats <<~EOS
    dhictl is installed as the Docker CLI plugin `docker-dhi` and invoked as `docker dhi`. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
      "cliPluginsExtraDirs": [
        "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
      ]
  EOS
end
