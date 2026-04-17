class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "6cc38f4170359a80b7b51ac70dd3100552c911bc55eff2504ecce6c81db1c2ea"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "826dc2b8d297962192453ca2c0693c3fc530d849e04c73e44e805f9ca44f1cc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59a77f6f76c157d7bdb62cbbebdd1af3f387da1de131fb1b8bdcc8149f1872ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d109dcfe995ddabe71c17ecd2c0d6943e2711fe9d9271bb540790f6445a6f82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e9c307082955b7ff46a9c7af6ffd80363432b60154b467cc202b4217b5811db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8b1738b8813f5f7e9a74c73f3bbf6ba0b95cdb56aaa676ef86c59e641932b72"
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
