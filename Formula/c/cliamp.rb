class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.27.6.tar.gz"
  sha256 "bcf58d6c093783cc02e0ec849b1b4719f7fcdd560d864ba005e2eb47e79d51ef"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51d528712c825019af3ff5da465cfd04f3c0fff0c41ea54ca26c36e023eeb45d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d81ec23da7b63560640471540c1a82a48811c845aa4b1d6e726645b691a2e8fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c9cb372fbd4e394f0ea0ba86e7062b59e503d66cf9c3d6bc8587c25a78ab191"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c33f4ea97341ce6d1de90f4cb36a55142f78e8a20f96aef7e6754ef6c6f93a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55f02b053fb7911fe2a1779a611b771f3f8cfb46e707d3b754ca3c6ad030f482"
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
