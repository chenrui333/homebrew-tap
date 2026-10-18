class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "875e19a57479f79a87dbf21bda4d5a25fe99f65c38caa22b73fd4f6056778756"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa9568d8a55eca045d7dbc258c56af96a67dcbd64761372e46ceee3fa2296d9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d566063e51a39d76fb0439c757d2a283eb7acbc8c8b5edf89fc593a1e242cb47"
    sha256 cellar: :any,                 arm64_linux:   "c077dfbf9b0b9753a7fd89b5de7d5e302fe20055ce609120f376dc7ac14d1609"
    sha256 cellar: :any,                 x86_64_linux:  "82df8fb826a096b19b9c1dac4592cca85cd330deccbd5b64cc9a482dcacec1b4"
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
