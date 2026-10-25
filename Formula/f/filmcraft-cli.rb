class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "6ad642d7e6cc1ad95bd44183ff00813ee978eb78a983fcd38f3f98336b8ef4d1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58f77f99bbfcb1c8a0e2a7661fafb85151fcd48212d8ebc868b767aae2ffb3f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c012c1127c86b8329208f59ca031fb5d662256d0dbe680f44e9ac931962c97cd"
    sha256 cellar: :any,                 arm64_linux:   "a56bfdf562cb4e63089625b588ad48140ca193750a6a5c7766d7bd9083aec95e"
    sha256 cellar: :any,                 x86_64_linux:  "d2a4a418adcecd09a45326668bc4c5fdd0e8281af0d64a07a6eee48545f0bca1"
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
