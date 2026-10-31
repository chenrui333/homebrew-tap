class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "90e7420d0bf00d2159667c429075f39391ee623ffbc866dc9b0a13e535606be3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d39445a3b064f40ef802ac7df288e7274538a29f951a7d34ae06348e2d96bdea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4937a6c8a3350c242aeb0c9089a0bd7e253f9668924d4638342b572556353bdf"
    sha256 cellar: :any,                 arm64_linux:   "0968185a829520cfae0e233b18260457700b6b946bf4a71562afb38c47cd3c31"
    sha256 cellar: :any,                 x86_64_linux:  "63d8bddc61d0bbebdbfa5ac1e775bce91899da46d868b9772227a1cc34b78ecf"
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
