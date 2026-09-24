class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "54ffbba6983880c915d2c13c83ca1339de2d2a3c5af3bb0a176923faa9afc015"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b09740a89e62152e592d693075c22302780e73fa1432bbaa4fd45a725bc63d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d7c023ca78b1670042a9bdc477114b314a0a25c21b764721a02ee89b80423ca"
    sha256 cellar: :any,                 arm64_linux:   "87c345353674d137d36bd689acf873a79d07dd8a83dfa1705e15fedd107112ab"
    sha256 cellar: :any,                 x86_64_linux:  "553e27764d3c281f5164db7ad659686d97b1a1cf90783a10a6d13806658a64d3"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mpg123"
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
