class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "716490cff2874df30261cfa8cd8ed3e1824c52b9c79ca6b2e662f849df16a43e"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30654c09c3f3564163230a2efe1d70b22938bcc8753f1d25a93615717a8995dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "316b59e12fc38610f037c0eae81d3256be7fa0725d5b1e59bba9906fa7736610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60d61c1220c1c1d55af3d6ed6c4ff8eb8957ab49c924fc221f174cef21f6d70a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a6554c0099b7a94b92df360044a96d9e1e3a1338a5574db5a9bdb2c51920b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76ef46485ff46ee53c5013e5d188bd648cb7d7d5888e0e6173a19e1318b334ab"
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
