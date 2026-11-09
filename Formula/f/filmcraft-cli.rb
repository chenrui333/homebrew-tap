class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "dd595bda36d4d7c8384020ce7ed6bd81f9a789c9f5d34f012d1d02c07186d543"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71b67d18d49280a5eeb92d1e943a9b970b72db20cfdd026953309759b272586b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0f803be82594f08ee6e1cbe18952c4ce26202d275158254db80ab7aea91acc7"
    sha256 cellar: :any,                 arm64_linux:   "99d6e8de8e339f56c4566a1eb8d5a948cba5f3ab0cf3a8e4c315a4a90f717b17"
    sha256 cellar: :any,                 x86_64_linux:  "c578f24e27f3f660f0d4e748f0510da6c95878f7d6ff1727958c06f47ef1a93f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/filmcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filmcraft-cli --version")

    system bin/"filmcraft-cli", "--demo", "exec", "file.newBin", "name=Homebrew Bin", "--save-as", "test.fcproj"
    assert_match "Homebrew Bin", shell_output("#{bin}/filmcraft-cli --project test.fcproj inspect project")

    system bin/"filmcraft-cli", "--demo", "export", "test.wav", "--preset", "Waveform Audio 48 kHz 16-bit",
           "--start", "0", "--end", "0.5"
    audio = JSON.parse(shell_output("#{bin}/filmcraft-cli probe test.wav"))["audio_streams"].first
    assert_equal [48000, 2, 16], [audio["sample_rate"], audio["channels"], audio["bits_per_sample"]]
  end
end
