class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "4615e11914d4256d972e66b00aa7affda6320112707a09a71d6d7ecfb0841f6d"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "725a582b5d3befe964821fcec1947844d41bb343af8e8ad8f3f0d3c74736b6df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "625907c3cba8d467923296becb6b6f3f670ead2d8411fa3629c5ac78e4ed965d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c22bd21a9719c8fa784d8fc12f6ea81a9cd2fbe901552770c1760fca0127cef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42f36dad1358aa824b55cecd3f36bb1f5e5c5a8a11d0a5c9bde66bc609329de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f850886e923e36246fe52157dffb6707bf8de616f1d8b2b5e8ba833d5eae28b6"
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
