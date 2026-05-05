class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "2a5db8f490422a7fb9405ff7061803a737bd11761cae75be3630cef05ccb4504"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6380d6d4949754b2a623473c765b9013947a4ac2454fa2225c9d16d4dc1f3a58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fec174e1ef17f69fb5d9b146e05e8ad86d3aef3a315c45129f53447e728846cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8434f16508ff9814190f8aca732840e045140be8054e1d562bc31aece1de6c20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dec9fd938c608bd8b7ba31ed095773e7d40dfec40e6fd5932a61e6e3ffc3386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f27d49c38bf32ff6f0127b58e7c402baf5616210239a20b5741fbe9833a55af7"
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
