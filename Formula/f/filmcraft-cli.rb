class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "875e19a57479f79a87dbf21bda4d5a25fe99f65c38caa22b73fd4f6056778756"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "739dbd92889956959803ccb73f1d4418867f3409e220a123d6ea264e5ca0293b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2efd40a7a3baaae633df39495bb3ec8053e6e9fc833f91d85d37dd33aa7604c2"
    sha256 cellar: :any,                 arm64_linux:   "8c4b193623f084c898cc400d052cf23628750e2d01ab1b98ecd91d9f115bcfed"
    sha256 cellar: :any,                 x86_64_linux:  "b39603a299531fa82bd63370ca7f0c7892c5dc472d8051c65c41b0942a18799c"
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
