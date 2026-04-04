class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.33.8.tar.gz"
  sha256 "e8d7d4ffb10287ceabc5e04591b2642ec931730fcd025be860c96307229700ae"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65e35d952279d2ab6054a719687893c1b8c93c0bc1860eecdfb96231ce55832d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81dc44cb077e6f66fd2dde88addabe72aef00fa8a0bfd8122ec390a9a3ddffe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1eab5cbd093ec6941a21f0a8b15524f682cfb892dd56b638056f74e668eaab0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfc0d9fcf44c059086a96c40683406506fe244e082851f1773eccfeef8117685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21e22c16d7f94dc8d7a038a557939c876fe6c28d8214bcbed5b691b1cd36683a"
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
