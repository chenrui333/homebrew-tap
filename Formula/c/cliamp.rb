class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "39bddf3f946d11f42d317dd5798699c2e964e813d18283c370c1781bb65f30b1"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6bea958cd756073255f09388741cb9b9634358b73524440936a71834c848ad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2936d334db67e0153ba90fa2d2436d47ffbaef2ec371292b2aaaadd6430332a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a07f753befad8b2014adacc98984fae8aa29169ce8f461e5fdbaad4c6024a507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38a641b8a22be2f73d9dd55de78de98d672b009d729b8ed34b97e06884e912c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3c3824a8831a3273a844c14a6713ab93420f8ce106a4a90717fa2b92ad56c54"
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
