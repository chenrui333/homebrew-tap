class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6b5ed01cbb1328bfb7c702baf58c7e68af156085a6ded4998ba95b4ebefcde5b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bba3ae517fdb470e6256eb60c85b4d88c525bbc02b0a2e290fa81ca612b993cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c87c5837cf709b29adefb4b1752ee6339425a96eb12092a008d344bf1592bf"
    sha256 cellar: :any,                 arm64_linux:   "50e998958256a34fd9d9f2fe5f4d4ce3bbc0248fb725c8b17e608f6c67e1abfc"
    sha256 cellar: :any,                 x86_64_linux:  "aff40a493768b677ebf0798614b7d13c273f79808fd94d86fe2631a20452a95f"
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
