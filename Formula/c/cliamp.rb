class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "9d7da1b1abc97b827b8524f30173e30a5087b7d2cfcf037288d899aad6232c11"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42958d6186816b61bd3ffc0a4cf5d6ef525fbef4e9e15fb0dc5081f2ba2e7d64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f88c99ca3cbb2d38f68b2b6c424b0ff8b2747c1f4257af4be6c72f683480dac5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d40abd7e924a498a1947b8d15ef16c8e90d2dfb808293bb89b5aef8d1c72a544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa2d532b38763a8510b45f41bc5c12ea3ce809756db784be071dd5d40a645320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc84550c356425d4662a07f8c4ed93c11b10d37686f9a5841b9ebbd98bf0bfc"
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
