class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.51.1.tar.gz"
  sha256 "7e38381e04238f70defddcc8989965bc95f49a0623f7c327e4f5919c4bab380b"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22a691603c80de521097e70a549d37669f928e8fd0b25baeb15091a582cb2431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28d36c932bb9a559480ebd7e17aa8a6cc99b16f3e3d9d0afd10f7784d7c39081"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df46d7ccf32f13d04f12430693bb0bc650c01fcd2e3ebf653e192496d758d6a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dca2de20e443d973e0c34e4983a955be79e99d9bd9009129023b86fd03cfb209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b24f1d395eeeb1e6bf0a272e6f8ce9d72e2ebd6aef9d706722fd4750a0e1ec"
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
