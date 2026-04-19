class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "ef781a01f5afd76e23c3b88e49bb7175a088c376834dec9f53361d346e359ecd"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88016800c3a95314db78e4b3366d84fb4fa7592e8ccba8a41bebdc3d1fd77eb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "183ca4bfb132a5b4b6e2c042a72f460c4c6190fcd61fb786adbe6e0d1c6a7587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42a4c6a6c7eaea6dff9dc85dd76fb853550e7d7ddea9c9dce5c376a35670c5bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a3cd0cec289642c01543983a4ed485f16521d667e3016ceea037767e705c61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd7be08c1b595cd5171e05fc9a3738d15fb7d50d6eea1f175bac4d256e2b285"
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
