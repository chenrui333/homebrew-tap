cask "docker-scout-cli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.28.0"
  sha256 arm:          "6721778a50bb4cb336db037afea0b4dd5ea6338d8a09672b3134c610b4e2595a",
         intel:        "e67baae5ea16ffba938f7c3394c2d3ebbbf8b0d3c4b9ad1a92fb7621e6ec72ff",
         arm64_linux:  "aeddeca10e51be71430f49edf8b313915f4d4ab092297a6e42ddbe188dfb6caa",
         x86_64_linux: "47917e325d7dd29f33678c7be7fc07dcbc1f424799f5397ce2cb3274c0421a72"

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
