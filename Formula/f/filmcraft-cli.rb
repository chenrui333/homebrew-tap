class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "83022ffecdc03adc113d8aaa54e5cab999047a92d0d531821a4681a4751d7dd2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e39c9127c2e2fb870200759e737f55bd329b08eb87615382089d1cc26b6adee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d33a1ffaaf2af0756ae80bdbaf533c9b43c5387539314c11fc44b51a960a75bf"
    sha256 cellar: :any,                 arm64_linux:   "6ef63750168344a854013170ca85b3606fba26a68da6f79d28461420ae9d9e0f"
    sha256 cellar: :any,                 x86_64_linux:  "862dd2eeb7e1cb69f8c24422bc6e12cbda1ad59f6bb265d86c97046d56656bbe"
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
