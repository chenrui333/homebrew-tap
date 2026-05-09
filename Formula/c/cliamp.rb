class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "378bcd68f800fb68652840cac7c253438afb0e7c0720c885e745c17d2aa37cf0"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8564133607ed9cc50236f0a16a32c65396959e8ad1dd0a65f2b338e689be6ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d315b55570f9f011dc1c273b2517e6e24eefc7fbacac5f60afd749fbdd7e8113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7be95d985ec5bd204b4d906a8aa11934e4999d3363e833e4627b38592a911fd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40965fb700d839041723ca186a8ff18f0fffa91bf1a506de31268f18534715f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16ceca0854188b8f4a70419242b32d36b2235a89979bb1c5859d1291fe93261a"
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
