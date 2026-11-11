class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "2ecbb8e06f7fd75fd64a7cb412368e658d2a0e25104448e0d7a84c97fe353477"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56834671b6ab3c78555cf25f24561264baa59b3f6ae2e86d9289ff573726a410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23aa69cc4ffaaadaae667828209e7773a97c3ebc11474d45198fcb806156ed39"
    sha256 cellar: :any,                 arm64_linux:   "5bcffa03fa568c126011a374fe960042970ae3e2bc2be4a23dcc7f37a38f9b09"
    sha256 cellar: :any,                 x86_64_linux:  "4ef13f1dd552bb34fa1ee9e6eb9c46c5b8668e25db52296b86218931da74a588"
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
