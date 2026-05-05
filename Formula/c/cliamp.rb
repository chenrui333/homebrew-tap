class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "56fd1fbf957289c1116ef6766312662fcf285817ed061db94b0c432d3db896b7"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e692f3f81569a2510e1a8e22b586e555b53fbbbc656b9cd6dedf7abc11ee31b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d75f159f75c6d69eb6b880439f5511ba12e172e67e824d2d1ee998054399e568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59984f9f168aef021bf849cf5f3d37400a4b5e7b55cc74e2e0f79bd6dfa4582e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c646462be87183ac46cb32db155d197942e52b7e903000ac679b858e7610e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20bd8412f7b5b2d1b1ebc4e87cda863d51cfcfdb67f1150413b2a2d71cabba1f"
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
