class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "02bc85868c0c703e52678b4716c9f10b6b16439df8e4f24f601c9dc336f0e15d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22d42fcca63a292c2b0f76b37143cbf5fafb8f165b9c74ed14db424e177c2b15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20edd6d77f265d7fd541f74be9d04d27237ce89f22e25b69c12c375e19635c88"
    sha256 cellar: :any,                 arm64_linux:   "c9f651f8a0dc176501ea9fea72b3a5d45cc99d63f5d573fbc8258dc012ff2267"
    sha256 cellar: :any,                 x86_64_linux:  "833467bdda1491dbbc9054dceba24805b5e13e795da317311e400b074ef6b2bc"
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
