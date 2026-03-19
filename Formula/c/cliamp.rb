class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "49f52969856487417ceed4d8e8088992cf7cf8ba59a5ed927d75322709b5361b"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c7444a32ca037ddb86bb9dd7f0fdbd97ab31ac2f2366de3e04a173c2e0a50bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa0a9c5978a60a03971323f648cf35aae7743785344740a92866d2542d6545b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4effb48ff2a032b51f1ab7d46c5d73440d51b095d5c73221d5d3d3d5633d07c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9abf041b924e8315344c3be2f69695bcb171c88a3789ab7e8154719f9b31691f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8bb660801ee4e213ef264bfba11450dbfdccf6c8bbc0f3fb7d16cbcf2a9ef16"
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
