class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "6ad642d7e6cc1ad95bd44183ff00813ee978eb78a983fcd38f3f98336b8ef4d1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3353e7723031c676f6d0e4e6a2ad75c888ad56cd2d700ac2761e82ee9744c62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1589b86e0b1305493195d8a6adb59f3613df08db0beb230996297da026968ee0"
    sha256 cellar: :any,                 arm64_linux:   "dc7843d0e0db6d6feae348edea50db6d0dd1f4b553cf36e277154b05c4e48a12"
    sha256 cellar: :any,                 x86_64_linux:  "2ed9bb850559a8db753e8de80a2b4acf64abccae9cf4c5d0700f0d56910e089c"
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
