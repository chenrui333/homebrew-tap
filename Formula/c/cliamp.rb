class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.47.2.tar.gz"
  sha256 "d59996b6157c6cc855bdfc52355edde75a56ba28d1665f5d32c84f07f716eb09"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be669119b15cfb3bfcb3a999cfeba4c7f710a30dbc55c27acc0ec81e9ab1ee6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7802327cc7f3636398887cc691aec95abfefc790e1b0498c2863d62cd0159fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "889cc6cdfdcd5519c32ee2cb6f88534ac2407568ac32b5bdcfc51c35b3cc81ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c30916beaa3ce41ebaf9442fcfa7f203a2c91d4ce22fc8efeceb7bd2fe0069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13010c5e1666792e5f3c5092b4f32234c7b9100e06c1b1b839934bb27191b203"
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
