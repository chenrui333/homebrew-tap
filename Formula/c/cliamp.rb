class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "89fcc75f4443a5e7ce5b08a09a2368278bb47e15df1fb0fbceaabb443e29662e"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ec50e343084a0534085ce0469ce74894ab7465576d1200824557cbf8b5f02ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "971b6bd2602b3e2a6ff77b9175a69d3c9bc1eed899ded2e307a3e625b7ef23ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9b6071be90b0b3d0bdd0618aa594186c8e0116213f6bd5c8c1d6046ee0e9f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934168b9e3f4b5058b08eb6d03808b294d981964c5e7f00d2ffb76bf4c57e1e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574952ed8613069e61ad717e4ba82cb0e55f866ea8397908384411c591b55f2b"
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
