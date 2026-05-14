class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "2cd8108f5df6a496eda9abf3969b8be4b6c7d1490f224372ae4492829563c417"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eb2c931f554f931ae801eec8ab8c0a47109aa74b1781dedc106ff2cec9a33ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b95241c7aa339175645c4d01543b35badfb98f858fc7ba213dfbb08937f9036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36b01222da14d416bb193c4af9784333bca337698278c3d2352ee0aafb634857"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c9dee8d680b9e3c990cc90e3b9b84ba5066f006103ef2f5f130586f2ffab310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d5a032d27a22c70c3ad83b32126baafea3bfbfbfac5fbe0cc9266e419ea11de"
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
