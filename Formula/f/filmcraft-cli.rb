class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "1f442d91aa31858ddd4dec9817a466e76c6dafb47f3e402f0f8b6be467c53fe4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbc0f6ef99499453189c076690d21c6da1fa9ff88fe1d5282d38f78e6195ee7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "178015937a8bf41170901e5073b3c4f15b720d9e5658cca607f665831eff1c8a"
    sha256 cellar: :any,                 arm64_linux:   "4e6fac2fe4fa1ff030380e579199e2a06484f72623e6e32523ebd786279cec75"
    sha256 cellar: :any,                 x86_64_linux:  "01e7e85d271aeedb4bc396ff8ca5e5b4e88547c7267b80b9f1a4e08b9614366f"
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
