class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "168690d8d6b7df298de579bd62ea4312f1a662499ba636cd8b2d8f2853a7fc67"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0b370ce03eeb4d9635b283518653146f9e83d405fb39bbaa1fbc5384e1348c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf44e6bc896241d0e3bbd98419b019d73f89a004db3d0cfa56ff2309dba1cb9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e85d6e615361b5450d4901cf4102ab4f2af31a73869482b19964d119d2e2b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cd2743bf4e1616cc74000de1ab1296261a4d6fc193737f198a26f1fadc4e263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d5cdce1c60d1cb2aad65c742929d52df9f6d71d71ce2fed0ef88f1c9aba7d5f"
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
