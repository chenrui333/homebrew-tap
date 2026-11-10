class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "3e6878dc590c125ebfaff48d702fb37fffd9c99c98df32165c1efa15ce6ed725"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "964f8adf0ed3f9b36d08f5e7db02238d8f0250182f4a5e4d7913bd19d3b15f1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a490945736948ea1b5aee676484e1c99f9cf950a42f5568e7a5d7d5e3119d6a"
    sha256 cellar: :any,                 arm64_linux:   "21f73426c298546b3e5427eb56220ea1dd5ae2ba7a2bb9c6bb385a37c78adf08"
    sha256 cellar: :any,                 x86_64_linux:  "6eaf0e00a8d618dc5f1811af36f37fc3c5bff6c167aebe74ed5be30e8182ea5e"
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
