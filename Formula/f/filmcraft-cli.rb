class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "430de17dcf3c63223064e6f23c889c6abc4a2f08f351e0c854ff518944f9b60e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7360c071e9cbc3da14f9ca8bc03bd3c24ef1cf2139340cee9d25bf3e67c0bd43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ba3c0f09edd93d094c581c21a3e6c239c7c7570a002f678e2ce7e8355177e03"
    sha256 cellar: :any,                 arm64_linux:   "0965fe9abf7988ccc8e8d3139856a5ded49c5e9274385878fc3763d10bb099ef"
    sha256 cellar: :any,                 x86_64_linux:  "426f81279cc76c6ee04d4c582a98bf257a0a00eb6752ea9298dfd9dbd0535d00"
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
