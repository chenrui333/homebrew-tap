class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "11830c137e7b38ec4d5e7ed9223077014811a191a22e45a0a727204a23ea1088"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0db5362885507e80c70e8fd54c03e7bfc1d68ec91a63c734f2e35f8a14403616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aadc0990dbf5af4e4f39bc7ac2568bf42d670de875a4dc55627b207f4a0aa08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff08b4def15dc410e4436c0fb30336f966d54a443a58ad03a8844e8ba9f7f6f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef6d84fabb8e9960d2260ed1265825cf471f6e0a0296c05a43370e2592b99bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf388b6c14feb661886708a514ea6499b6209feb4410852d768c2d409787aca2"
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
