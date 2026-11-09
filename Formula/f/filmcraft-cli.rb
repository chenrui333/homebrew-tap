class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "dd595bda36d4d7c8384020ce7ed6bd81f9a789c9f5d34f012d1d02c07186d543"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c4adb09b99a63a59567af5b1cfb8aadc77a5496a8992e5891d8c863d4860186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "881c39aef5328341a69c899a47e2d4cacd059144a1576d4cbf6b1ef53b230b5b"
    sha256 cellar: :any,                 arm64_linux:   "503e867f2cb79feabe16b6988855fecc1619bdd2481c0601edd61e46f6e3c55a"
    sha256 cellar: :any,                 x86_64_linux:  "5f9b6347c321098103dc5947ff3fabe2b819f254cd79d8252e156a54c9c84384"
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
