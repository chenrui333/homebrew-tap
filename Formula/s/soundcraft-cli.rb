class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "6d419e05ac06eb71347b82c4eded09201c125c781d41b3cc5ea07d890141de95"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aca38fff0dd7b1b2c530f32603e58095e5201fae0785ff8e7828d3bdc519160"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b02b36510d92c8cf95b1ad57eb4fdfb97649a1bdec88650b2bb51d218a1448e"
    sha256 cellar: :any,                 arm64_linux:   "3bb8907ea9673ba6a774f3c45fd06f03e4257f0f8db19bbf093e28f87b6a0109"
    sha256 cellar: :any,                 x86_64_linux:  "09de7953c660617d62a1c6b8f90e368a847f4f7a0d24380ebaad4a5e4e7bae70"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/soundcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/soundcraft-cli --version")

    system bin/"soundcraft-cli", "run", "--demo", "--bounce", "demo.wav", "--start", "0", "--end", "0.1"
    info = JSON.parse(shell_output("#{bin}/soundcraft-cli info demo.wav"))
    assert_equal "Wav", info["format"]
    assert_equal 48000, info["sample_rate"]

    system bin/"soundcraft-cli", "convert", "demo.wav", "demo.flac", "--rate", "22050", "--bit-depth", "16"
    info = JSON.parse(shell_output("#{bin}/soundcraft-cli info demo.flac"))
    assert_equal "Flac", info["format"]
    assert_equal "Int16", info["sample_format"]
    assert_equal 22050, info["sample_rate"]
  end
end
