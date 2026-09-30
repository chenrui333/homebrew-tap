cask "docker-scout-cli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.26.0"
  sha256 arm:          "465911a3ffd218da611ebf2cff5a9397d2b503bf1629a0d7879e6c88e11db04d",
         intel:        "127e4a22f7e46476686f950d026dd9f839b35bbd02539eecde0634a65d34d497",
         arm64_linux:  "34282a50d6787eec46e44a377a1ed9e70342adf078135cca8617c9199852725c",
         x86_64_linux: "47daa9ac442816316c65389f516b847146bb9f45e8d6afdcbb9ce835c4e138bd"

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
