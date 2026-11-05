class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "2b0e75e02cb3036ab885336ea8b53bd9642bbd4001cc67f1725a80fba83b817b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1efd414e1fb72cec66cbd9e484bb8dc23c6429cde476ef587fefebfc5ee275a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cbf34c77ac3840a126adadb25a4883049431cbb950769daca2ce907c97e6eb4"
    sha256 cellar: :any,                 arm64_linux:   "5af9261c8aebc3029c81bc1f75651e345ecaa566fa0974a3cce05b88e9a6eaa0"
    sha256 cellar: :any,                 x86_64_linux:  "d6ccd0a94ed024ede08be83ad7743749b18a1e0edef98bc7ca09019433f29476"
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
