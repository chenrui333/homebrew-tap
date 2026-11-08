class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "7375f75382f685edf4c01091dbb6dd393036f8a37bbfb4118cd8e43379d0fcbe"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8508dd3d0f830c549b3f51dd7c6a8647df45a33321548be169b38b879288593"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1921a4b4267aa425f7d00890c34735015ae6b18f7f10e6250500c063e6153f4a"
    sha256 cellar: :any,                 arm64_linux:   "1c468258ec7602997539f7b3a9c190b655eb72bcba9d72807a2966f6143ac60f"
    sha256 cellar: :any,                 x86_64_linux:  "a6ebfb0998bbd004b4384b0805fb74d29738e02af38e84cef83872f469cc2b36"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "yt-dlp"

  on_linux do
    depends_on "alsa-lib"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"cliamp"} --version")
    assert_match "No plugins installed.", shell_output("#{bin/"cliamp"} plugins list")
  end
end
