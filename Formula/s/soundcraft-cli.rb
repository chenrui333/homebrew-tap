class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "f42cc2a9694f363d8aee67d28031c1910856eb8ba1fab71d92a62db49d8cd1f1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eca8ad27b7be907795dfe6966edb053c58870adf614fae53f4a7c64942653f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9289e0d6a42c1a1b32830c1153dae714f2a566ca5fc43312c91bceff0f5e8892"
    sha256 cellar: :any,                 arm64_linux:   "534b956407e8c56364a911723fa7bf0f1d960ad020f7dd8d13a0f0db35a4325f"
    sha256 cellar: :any,                 x86_64_linux:  "8bca3056b39832289368e1f3f824b44ec60d06b39ea2aa79a9431b6292ba1ba5"
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
