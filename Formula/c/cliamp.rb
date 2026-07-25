class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.62.0.tar.gz"
  sha256 "a6f9ef097ea1d4d2a4d70d5ea3fca4999458b9be3941ec96c1c3ea911237713c"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7af239fc1988577c687346787e9ccd2dbf5e0a19b5c55a52cba184ab92fbd4f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b21c743f8bf041de568b611bd1906b44d3c3a69923eff23db1cddfa68453904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b48da0ddf7fcd0cf07a2e78ebbfe800a6755ca4506444fd09cf14a165ce9ddc0"
    sha256 cellar: :any,                 arm64_linux:   "02b11eee4a7b2d37c164dcde8b2cbba475adbba6a73b4d0d1358ffb0a33a2dfd"
    sha256 cellar: :any,                 x86_64_linux:  "3419859432941fb0466a2c155210ebf6232edf36764b25fee9a78ef9b3f81c13"
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
