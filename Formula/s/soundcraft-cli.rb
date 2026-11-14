class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "f0ebdb92df0e25806ec7e4678e054e88f49dd4f2e0084d251dbac2c147ec4393"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff68191db7eb819265521dd308b895dc0f7505a7839f7805ce2955485108ae35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "834acd76ec6ef65abb86146db80465e94012a8312918ade49542c6dcba3c1dd0"
    sha256 cellar: :any,                 arm64_linux:   "d6d7392005df682be51c471e01b7ba8ea12493bf3215048cb40821324be19077"
    sha256 cellar: :any,                 x86_64_linux:  "82b82181f824cbbcd9a0eec9b60980786b1d0479b395ec81928b7e2ff087989b"
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
