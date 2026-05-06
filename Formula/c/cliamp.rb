class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "7c04a91a77c4e458dab95886472b70e2c0e7c449662baedece88975bdc6b33b1"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4ee0bd95ad020eb72965f7c920901c580b9d465d07b95bc76405d0907e7b347"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5a89bd324907a6fa8a1300a7b865a335de4c1b0e6ae3994c7616500d6668916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4072c65aa4d7ed0e26954ff6bbdd610cef41fc9a621d69cdb5b41a76fd230471"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a029efac6567534c1feaa3bf1e1dca69a4ff68c24f1e8516b812cee698e1de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4d4a98ca415f44425f4ff64c696d0743051c76b5f8e9f2464cacd6d7b05b8ee"
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
