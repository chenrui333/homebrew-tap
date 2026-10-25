class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "f42cc2a9694f363d8aee67d28031c1910856eb8ba1fab71d92a62db49d8cd1f1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be12f3adbca4fd5f832cd1ced24c6a5e3da3d0f51bdf2e51bd056721b503056a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3de493f3d1a2318992138c88583eed77ebdabbcdec2125723a88e009ad65db27"
    sha256 cellar: :any,                 arm64_linux:   "5d1f99dddf3c67ff4367cc9e74775a69ea7c89ecce6fed7d298e5cf1baac1999"
    sha256 cellar: :any,                 x86_64_linux:  "447194534488d92252e3526caa41f80714ab794f949618650cf4e4f38312f1b9"
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
