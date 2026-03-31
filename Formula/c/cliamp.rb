class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.31.7.tar.gz"
  sha256 "1b21bb69473c0429d0883bd48095cac49f7186b854058c6ea89a58780e1baee8"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21e6f52fedb05ccd4df239563bdd71853befa25bfd7ae8c05657c0dfeec9ed75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "876002b3d58ff939186e5cb29f2ecbc99cde96adb8e41067ee33cadb440b95fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c504f0ec6e197008b6c772721d9f52db87e548c9fa95a6a7790164b2713d8fc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8d467fc95825d656381d10d42856e7bb622b018b9b3acfe6c42c644a5356a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80249fa33f4b9ef90607cced9e9ec3e801cf756c49c858c617e926a9548aa43d"
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
