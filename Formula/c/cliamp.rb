class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "3afff2a37cd6988aa1eab2614d6dd0c032fe5fd0ec95488a772b58c7e8edf076"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "388d18a43a16239d50f8a2186453679a644576ad8ad3470b155ec260b0fdf955"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfe319b24b27ef053fd4700cbb8b4e6bd1b498a529109cc401ed830ed7140ac0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aef1340521838eab41a81a19c4a7834114a84e348f755b49a3f98bbb20c7fe05"
    sha256 cellar: :any,                 arm64_linux:   "071fb76725fb445bbb2bd338ee8a851bbc28632dbe1996960d7466276001d9cd"
    sha256 cellar: :any,                 x86_64_linux:  "70398c5e7ad84cb781c1a53585e18ac28a078a4abbf048c7bc6c66c687eb35c5"
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
