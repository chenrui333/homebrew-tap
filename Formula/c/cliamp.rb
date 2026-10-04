class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "51828895ddb5b236fa0a119c1f06102c127065bf44911849c910fe798362fec5"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19c93b4ea27339fe2f929fa2ee40ff42d2950c63ebbd2311ccfe7ff8b8587231"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "115afeaeac04bee11fa063e643eb9f2d2b07a827e9630e9dd29d790fb7c17473"
    sha256 cellar: :any,                 arm64_linux:   "ad4d8561bde998e4780066d7d2ab5ba36ac8b5ddf4f9028b298f486a4556a8c6"
    sha256 cellar: :any,                 x86_64_linux:  "1c92e675767f535e5dd18fc62ad5e9d56458be9faf05f9ea797f743964b28726"
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
    output = shell_output("#{bin/"cliamp"} search 2>&1", 1)
    assert_match "search requires a query string", output
  end
end
