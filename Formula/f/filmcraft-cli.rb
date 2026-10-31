class FilmcraftCli < Formula
  desc "Headless FilmCraft CLI and MCP server to edit, render and export video projects"
  homepage "https://getartcraft.com/apps/filmcraft"
  url "https://github.com/storytold/filmcraft/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "7fb0bfef6dc50dc9c2281d0a3fff67df43f4cf5c1e5c2c94eb447b25cf783fb2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/filmcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "701903e31ea6f2061d7632c41756f02c1b80f585211aef81128465dc9329b2c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1794ab3c824311aaffa0a028a948bddf7eb8710cc9a074d49ec1cd9e5752f5b7"
    sha256 cellar: :any,                 arm64_linux:   "28066e812afbfed4a2b6ce7bbd3882465a29e5b564fae5bb9f984186a330697d"
    sha256 cellar: :any,                 x86_64_linux:  "eced2a112eac977db1fbc6d112b4474d4575b9f30e2960262af92388250ced65"
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
