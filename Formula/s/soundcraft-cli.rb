class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "935a795b498c1cce6fe63fe117d3877d8af8f05150fe712089159d93fe840e40"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "703f97340eedf0af62766e915ddbdab7d1e647ef119fc18b12c0d147228658ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0badc10624d2241de2b31b954c08b847c85de57969773b451f3a86806d904378"
    sha256 cellar: :any,                 arm64_linux:   "4b1cf408878076285b3ede4a663f5523c0a9514c48b538cc2ba8a9d7026e2a39"
    sha256 cellar: :any,                 x86_64_linux:  "9b252a026bff1ca5de81338ad4dbc91d498d3ece34a431fa5004c5124fd7a450"
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
