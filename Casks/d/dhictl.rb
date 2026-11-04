cask "dhictl" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "0.0.11"
  sha256 arm:          "a2266010007ccd7ed314f695c77958d8d46c8e8db678806f9d04e92e7e190be2",
         intel:        "41ac177818e499ea679d48618085ef0a0ec272ce152a3ae41ed5bea6304a0ec1",
         arm64_linux:  "d83c106efea4a5e34c212917ab0c8aa4ece3988e57638ceade363e1e9ae0b2aa",
         x86_64_linux: "69fe750c721fe48150433bcf0be5acb78281ba9cb8286fd40d2b261a6b6e7567"

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
