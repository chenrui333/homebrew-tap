class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "4615e11914d4256d972e66b00aa7affda6320112707a09a71d6d7ecfb0841f6d"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

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

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cliamp --version")
    output = shell_output("#{bin}/cliamp search 2>&1", 1)
    assert_match "search requires a query string", output
  end
end
