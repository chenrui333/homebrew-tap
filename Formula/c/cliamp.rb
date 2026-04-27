class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.39.1.tar.gz"
  sha256 "4d93784711c1ebeaed11406f298c93a65d5cfcea2a10b46ca9f553f6db7883a9"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e660fc706fb30997957711e75573237a9f19e0d59ca12fc58f52ffbf7489acc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "730da9d735a81264e997780a31b9fcb140d7f6f150e7470aebe94cd0c4448b5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bd2fca0b836567a07070a426b21d791c0e22d924ebe3976316df679cb966516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfecf1e521b3ba1c2aba7055645ff660b0120dc25c1bc492a8fb505b52049b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50a5f7a81e5dee7a48aad6c5754e0c187bc37afa2a356738a4f4dbe2d7c8a917"
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
