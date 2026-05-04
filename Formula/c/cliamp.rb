class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "8860a23b49711aa959f6c20ae68ddfac1f9bea7c73e83d694e8c92fa70effaf9"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a85b8c8c36c7c97ab8986ba0498810253744a119eab5dac69655e8f49bd49bb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "785645e6fbc7ca1bc3edbe24f2627cb0e002423eb11799b30e5735c172ad93c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec675d3bfa9d1b4809a90ba26e74d129a2c327b18f0a88fc9e7a811c1e773bfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2689d42203c25f9535074ad92be5df9656d832ee97d627905af4103f6ba3f953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20958d7b6353d170ffe18056810e9a80869b222b1d297f0208342396e72f5650"
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
