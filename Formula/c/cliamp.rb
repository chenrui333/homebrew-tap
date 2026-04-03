class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.33.7.tar.gz"
  sha256 "33ae9009a7a35cee1fcb2e0d3a2530f7a98cc77566bfe753c3f640d4202f0b70"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d494ad315972fc0e405514c91809fa85a476062c9836385e05b1a860506f7239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1543d4e39af2703784ee833583ba1eeeb3c3c1369f49ccbf11b061dc8ffd32a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad94996e1f369dc628281912949b9f65c2c03c315c7969f25aa284d956cc5bce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d29a161a436eb68fd4f4c63d7d5ca577848cd37736a2d2433e2e36334c16850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3335661b3d29e288480c26c5bbb089558d44c1437cdaa586b1df34d304f7f6fa"
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
