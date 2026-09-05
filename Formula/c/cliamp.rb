class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "2c5885665dba5ed2e8dc156bce64751199a92efed7f63959c65e985759b73732"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71fc0d75fb6f44f770abe21b55b6ee00a7b678fbeb4ef52014a2c8d198399508"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce80339e0828ad4130c5a49abb9e14f909e93eb2bb388cc5873a4c521606af4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68eca24f64b9afce8f7e1a45795a1541fcf9077c5e409879ba7ecf2e6c3a57f5"
    sha256 cellar: :any,                 arm64_linux:   "eb73227a93760a432c803ba70f23d87d049d668ecf45549a0f1c90984b0ae519"
    sha256 cellar: :any,                 x86_64_linux:  "a06ea057b88511abef56f737422f0fd8232e789ae633c40f8c68b534fb726a1e"
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
