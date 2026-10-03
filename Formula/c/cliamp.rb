class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "51828895ddb5b236fa0a119c1f06102c127065bf44911849c910fe798362fec5"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3ca0cc96871f0ec5f1ba7eadec6fd43c93b095035813170e5ea391c6e7d2597"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "713d68c80dde871a161db30511d6d9d166e68028abbf5ba43a03c01d43b59565"
    sha256 cellar: :any,                 arm64_linux:   "379598eb414e293569c2b06163c52e0d6f36e581be7edc22a274bd0262ff2e9a"
    sha256 cellar: :any,                 x86_64_linux:  "2668b34a1531eed235d36951615705c9443b7375e870e2eba8c1c5317c01e21d"
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
