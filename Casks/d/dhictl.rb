cask "dhictl" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "0.0.8"
  sha256 arm:          "3c156e1bbc0350d24b8c2ab1aafdad7c47410b1a8280c75286ad493fdb68e122",
         intel:        "4dd017462d0a0513f386088a59c81e31e85c3cef3d8b3ee593fdcfea58798ee5",
         arm64_linux:  "a8ce108a8a64b37dee2104cacc2323c975ffd8881f111c2191958885b548e0e6",
         x86_64_linux: "62054e57050b26c867fd7644dae30d8c05585791adbe80d4ee3a084499975e89"

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
