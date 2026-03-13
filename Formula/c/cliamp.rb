class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "4615e11914d4256d972e66b00aa7affda6320112707a09a71d6d7ecfb0841f6d"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fbfa9cba1248b25cf53564aba879fdb27559a415346d593cf517023f2322982"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8323495679807a22e66a813e812c9a0353fc7846a99ff8aa8ddd7fe97049caf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c8d941bde1f6125cbdacfcc4cfd202f34d224832867182fca412ad4961d51b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fba9d5da1d02bce2a59377ea0819c7acd4054b5218518188803a7c2bdb00c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05bcae130a5c733f734938405f759e0de41acd88182bf8fe879a9a907002b60a"
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

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cliamp --version")
    output = shell_output("#{bin}/cliamp search 2>&1", 1)
    assert_match "search requires a query string", output
  end
end
