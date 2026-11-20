cask "docker-scout-cli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.30.0"
  sha256 arm:          "6b6eb97e64e19b9e2f2c9f6685a76c8866ee0c2a0831847ccbb3dbd313b2b176",
         intel:        "bbf36878792568164b844b28120dd94aeca72d6ab86278f6380b41876c641048",
         arm64_linux:  "4396c268e310d692e2f1aeb41945e7acbb1829e0ab3d938f0bc9304de70cffaf",
         x86_64_linux: "bd8d24896d2aa0f9e01d25830ac53cfd416a3254f8fbfce2cb10bcd7a1afe152"

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
