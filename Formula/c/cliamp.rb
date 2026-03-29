class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "ffb1fbb3dcc31abd938c5bfcbbd25bdc1ba3c57bd5a7daef622466b0898bbb19"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ae5edaae2ec5c67728fb5728508d1138d2db24c7be5eab5eb75910a86b8158e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82473f421f2abee13d3978d826fb8ff26a103c1de9fbf4e6087a8e64f5d3632d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aca43b2b6b48e81a79d712edf22d52a760478d57c199ecec4b3c6f535e28504e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f32031705806d135cb91e268516744631b507f92f32acc136048d5e57d81be60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f75917dd67d4cf71ed87f109025d604aecbe3f1e4f98a01f25602320fee418fa"
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
