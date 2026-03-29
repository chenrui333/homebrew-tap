class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "a0b916382f1a888973ac43059e1767f4d73a5856c4c84e5b12fd129feeed786c"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f761aee5de292764b33d1b8d51f2239a02f4c4b1f38303f4165bcbf3d7e5e58a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05952d6d66b15fdd03e0af93d136f66f791e04f41d14451dfdf13332deb9fafa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a8605a3625ff839cdc113d920448e165d2e143b22d5dfc79c35ee98dde8e0c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dde9294c6ab423ac4a9c8b795e4e143562d49560a46463efc2401b3d4faa2702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17179dbc4470cf657197e321473d79ad2a6208e0b7943994044adbeff77b1254"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "yt-dlp"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"cliamp"} --version")
    output = shell_output("#{bin/"cliamp"} search 2>&1", 1)
    assert_match "search requires a query string", output
  end
end
