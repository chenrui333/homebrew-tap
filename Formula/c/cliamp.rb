class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.60.1.tar.gz"
  sha256 "b344c4a7355d9b04840172e74e6c5fa171c7714034085111bf8cdd80a1b9d9c9"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3270c7a63951b99bd6e2f920e60b3ff1e9f06eaa6d1a33341d24b618cb95abcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbcd3c5296c8d7ea485675bb4f398e05ef586faa164de5c3655fa9b583768362"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93fe70e8688baf07751ee0fd254f18564d5f6762e48e7395b19ecb8310cb3f9c"
    sha256 cellar: :any,                 arm64_linux:   "c5e52bb3c8e58f84394fd60cb748f7bf9ac22aa2c2824b3ee872752922b3399c"
    sha256 cellar: :any,                 x86_64_linux:  "6689c7ef3f5765122a73e12743dd8d43b3b151176a18896acfa1442533b12c53"
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
