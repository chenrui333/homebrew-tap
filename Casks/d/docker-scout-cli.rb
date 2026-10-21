cask "docker-scout-cli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.27.0"
  sha256 arm:          "239f98a6ea1a7f3b8e44ceb1d56b15049faa453881744ff564c3ed1885b391dc",
         intel:        "d8a8b523caa0d4741145d7f73cebeb19ec3c32e57ad89c76ff451ef7ede6cc93",
         arm64_linux:  "3da088c321f55ddf2c2d1c5c9d49c66673b7a978a8b2b65f6a1ca9a3944dc3cd",
         x86_64_linux: "815207e27559fd3d7dddfe778e86f0aeb823eeb24b3cd79d00bc5cd8dfd0724d"

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
