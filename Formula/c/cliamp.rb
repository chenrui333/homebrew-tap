class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.63.1.tar.gz"
  sha256 "e8edb908b0bef026012d1352b834a51f4c027647c82d521fc6329e54cbc9cc85"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ceebe42e8b40351fd0c6eea46e46b7484104b5cfb3d30b8e4ade1291ac93a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee888af0873a84ec1e03241dda110dd6a1360156ee50266e23406ca151f2e01d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6e30d1833e796da83263a3652aab3261c1a07568b04f31c78fc61da90340d18"
    sha256 cellar: :any,                 arm64_linux:   "97f31f370090a357d1513e65248e105886eef08f13c1ef0ef333bbad48882c5d"
    sha256 cellar: :any,                 x86_64_linux:  "4b16d1aa322c6330f83065284d34bb71b62d81eea3101515b22d50354007645b"
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
