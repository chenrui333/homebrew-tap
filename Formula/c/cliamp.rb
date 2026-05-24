class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "ceadb3d4b31fbb98fe169072c4d1da283b2dfb58e5271e1f35696daf767cb3a6"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3eaaa7d21c85f5cf6958c21ee3e3609762db470801f15219f456675557a8aba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5bdc825bf782c39ef7129c0595f57c2afa4c89f44f43a44c5fc1447adaed44e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bda58a4b124e360ff1bcb90b76b8a0424cd6f81f2ccada803e0282a962b3964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67483ba33d6debb51648cc26fe959cf91f4dd4b4eb07e87b6c5cfc6ec016e1c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8512d51182cb4b7c572b22a2e6f663ef465e7987762ceab92f7e30743ef1180c"
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
