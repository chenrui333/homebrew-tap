class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.32.4.tar.gz"
  sha256 "18698a15dfd2a8ebf2e8a716abebc4f0147c0a632aca3490561c3e44a2addd66"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cb3940552f617848d0b58fcc602c6ea4f0a62f7450fafad5f14fe52332f235b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79d4422f29ad21405d88c2d029fea77dc3b0dafc6b8d2f7c5523282b17136fdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97ef86bd80e76d87e2c42c7e81408f6c65db3e0c6635a3ed2fe8a9fd8485362f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2bf5cc735a370e35493a10689422f8fdfc106a70e0aa70c932275ae17f0628e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f649667dff5e228940b91aa396a5e3ef77428e0cb7786bb6c68dcfabc7e1729"
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
