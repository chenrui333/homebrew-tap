class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "c6ad0a0c94a603207da98a6a1f0d235d82af4908029bce351c4a49c3652dc96a"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "569883e05f8679d7c2ae8e04908e79861a6b636155c62593e80c8f162570d1f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae08cdbaf133bd6c76685555ae3868009c9b4d1ddbcf2f268a902c60bf2b44ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd273d0cde317afbe94e62fc897f552c5cabc0b4192581bb3f642e854a09beee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "840452b37f71d276a6f4fde6adb5e6c08adf8b332d0cdfcfd74615f883f87bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fff112d686dd3af290f468b8b2a26a85bf50aece24aaeec86de208b733987ce"
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
