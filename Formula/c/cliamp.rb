class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.31.3.tar.gz"
  sha256 "c3e03b0596086b09ef94aeb38632e9d8a07cf261f6240ba70798016c789c4f3d"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec923c435ea952b06191eb9288a211eace4790199b53e65807e76d1b6e6a2e73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "343e1c75fcb393df2f56decb05ccc4d766a305f31dd80dc08feda6024c9607a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0233642efa08758ebd3ab3973493cd4731788959bc4ea3caf1d4718c11597bdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "296ea676f13f17d5261774c608b930f1e5e793e090ae61ca4c0aca258e91ae00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c29f7600f00446e31dfb5a5c1997523a93612a41a48e05f64d649fab1c80ea6f"
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
