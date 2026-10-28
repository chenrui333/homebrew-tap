cask "docker-scout-cli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.29.0"
  sha256 arm:          "ac0eda010e3ac15c53a8beb3537d068565ab8109a4621273938038acac47e8ba",
         intel:        "51dff93ad721b7fe174b083bf9b6579814d7297c43458ecf14c7c55cbebb2c5d",
         arm64_linux:  "bcb16a65b7266413fea05e9dc352159485609e62a6cbd049207118b0aa7d8611",
         x86_64_linux: "9157cdc9372b478a8cd51dd53f5e9c74a7e34056ea291c65520bf76016fa72f4"

  url "https://github.com/docker/scout-cli/releases/download/v#{version}/docker-scout_#{version}_#{os}_#{arch}.tar.gz"
  name "Docker Scout CLI"
  desc "Docker CLI plugin for Docker Scout"
  homepage "https://www.docker.com/products/docker-scout/"

  binary "docker-scout"
  binary "docker-scout", target: "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins/docker-scout"
  generate_completions_from_executable "docker-scout", shell_parameter_format: :cobra

  caveats <<~EOS
    Docker Scout is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
      "cliPluginsExtraDirs": [
        "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
      ]
  EOS
end
