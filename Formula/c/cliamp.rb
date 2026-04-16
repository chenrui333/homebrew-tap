class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "356091c374ff81cb9e78bccff5add204bd70a6ff45e740403497781d08d42fa9"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6445210f192948e73f413a1f37e5e5e2d0dbacc4a147babc1756c653edfc8f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "325fa4cc5317db41620243b1077643bdba63a215df431982832ed0d64b564d7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bedb1f8e60b5174859f8a615d8f65ff66e57681326c99ba9031c006a9283efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c89179f43469ee67b62e554d72746ff1b966082f22c579815615c8bfc5b5fd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a937b0c178e3d59611661c305e89cf46b2db4c68762e46fd063a0e682a5bd659"
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
