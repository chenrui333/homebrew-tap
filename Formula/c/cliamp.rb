class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.27.5.tar.gz"
  sha256 "41899983aed6d325390dddaa3fe6ed2a3761ecec0a174a2dc421b629e88abf8a"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "080fdbb2eda143525c1148a3031f5b70da8f333d7b8dd019b5b5152f4efc493d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72e681d853453f60277397eaf3abab1aedac1e68469b7b1cfe647d74dc4d40f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e021c8a53e07befed2abece94618baa5589d15287999573a971918ef3217ced1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3827d1346d0b47000c50d71f229523ef1f41115ce045d722a312f273ea190ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93cefd85332cf61e7fd6fb2c80e21e019a5086693243b61d4a3904f64a12f97e"
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
