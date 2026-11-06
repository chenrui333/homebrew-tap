class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "f40cf2d16be3d707e80042748acbfed770854bdefef48840c11e82fa1e93228f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7df73d8d697ca2e6f42b71411cfa7dc081818e31c40c6742d6de24087cdae8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c59d279e9de2c332d35e1b250ce1ac66c928a146f0326cd7affae1037af8060"
    sha256 cellar: :any,                 arm64_linux:   "3e633addaddfa5341ac2e730e35dbed68d88ac5fc6dba0105889348f8535d481"
    sha256 cellar: :any,                 x86_64_linux:  "7b94e516f946d63b5ae7a6adbbb6858951c5957c772f4a739ce3816e9b47380a"
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
