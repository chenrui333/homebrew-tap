class SoundcraftCli < Formula
  desc "Headless SoundCraft CLI and MCP server to edit, convert and bounce audio"
  homepage "https://getartcraft.com/apps/soundcraft"
  url "https://github.com/storytold/soundcraft/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "6d419e05ac06eb71347b82c4eded09201c125c781d41b3cc5ea07d890141de95"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/soundcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0dd5166109b973f279f04a04489aa782bab7bf4f7f0a7c52819abc38b817e3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2034051331eb491e2b54be656a96207fa5f5744e5c8a1ed4ccdf3fb631ba7e9f"
    sha256 cellar: :any,                 arm64_linux:   "3278d765972166723bcfcf1b05e27ba7af11c316b886c60343f592f8cc999618"
    sha256 cellar: :any,                 x86_64_linux:  "f46712f6469cb84339da3c5942e5d34f48d076a2d571bceb6e255913d6c24f88"
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
