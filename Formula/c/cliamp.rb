class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "65ae0855eb36b353a38d77106ada45226b76777114e29a98421fd0c0274ecd9a"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc1a546cc86e8bb4734e7eba61af1498d9acfc3f52511368bb2389e46500b0b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a53fad1f1a805abdfaf1af14e2c71538b911d2b9757fe4bcbfcfde46005cfff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c93167b440f73846188be0df9a61154217d2dc9e29f2e3b4008efcc34a516afb"
    sha256 cellar: :any,                 arm64_linux:   "f583f592f7571a957314e4b1155c59ba1915b24e966497d1d964eb549704e738"
    sha256 cellar: :any,                 x86_64_linux:  "8f19d32e32dffaf1c5ea9d4da6c0fe59e45c551eb18269fab5cdbf2b4a689c0b"
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
