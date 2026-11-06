class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "421f4a85c82a66b2b81d28feff369d2d72f63f2c2cad702d6d8e56ce5cd38665"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd2ce3741f2af13bb190dc59236d5f672c1c3a1cf648a52d4174e395f1254c3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "458ee4952473e82031ec66353c1816eefbae55a61e02d3f22a73e36e4de3a429"
    sha256 cellar: :any,                 arm64_linux:   "8fef29825ec6dafa1f8d9e788e6c9b2f85bde8618425afa5275cec73c3d55b71"
    sha256 cellar: :any,                 x86_64_linux:  "46c95a1bdab826cb3f7d3b0f2c993b4101c64b82178a20ebcdc7073576337b3f"
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
