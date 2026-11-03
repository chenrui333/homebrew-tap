class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "430de17dcf3c63223064e6f23c889c6abc4a2f08f351e0c854ff518944f9b60e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31dde588a8466e530cf3a9e52e81590b1ba08d06f8781c08efa07a039890856e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e23e03c262d9f920b9151e0ab4dc5a1de03e05a0c20ab81ffa0f432930ec683"
    sha256 cellar: :any,                 arm64_linux:   "7adb32feef21fc0b1cd3ecfa5f8e7cc35395c9585cf11bdd098caa41016e8891"
    sha256 cellar: :any,                 x86_64_linux:  "9f0fcb1a7812d20c73c1f10781e023ed80a2fe655afdaa44018b2fce74e02d7a"
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
