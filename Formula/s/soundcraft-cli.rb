class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "15048385f07d0a6976e17eb1c665067724855e65f9b9a458a53b052585f1b4d4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a5086098ea32673b6ebcc5dd10550db63a5ee4f41071995371fb8491bdcad26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08489c46dbf4e278f8b2e7d7cc2f5c5856a4fcd3c9e7455f6087160b33e1637e"
    sha256 cellar: :any,                 arm64_linux:   "455510316a2c629683ead3fb4adc940651cb583e2a323095ec26a1d0f5bb9091"
    sha256 cellar: :any,                 x86_64_linux:  "6a9201c3e743737f569674d2f7e3775784c3ebfa6721800df3c63e4cef77177e"
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
