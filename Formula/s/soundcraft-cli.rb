class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "90e7420d0bf00d2159667c429075f39391ee623ffbc866dc9b0a13e535606be3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e57a21d1b7ffc54f61e51e791ac6fbe279ba6053c54f624b4955531d8a4b82b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5570140c4b51e83d807b95da0e7360d20cd7dd333a665da6b2cc2f4cbeca45d6"
    sha256 cellar: :any,                 arm64_linux:   "b071ef6d02bbc0ecb65bf5ae3a8df99e6d80ddb86b8de1b0c54018c728a197fe"
    sha256 cellar: :any,                 x86_64_linux:  "18a2460eb4f801d9c15f6500e88b9baee3cd4f227f446bf8c0b012d38053b6f4"
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
