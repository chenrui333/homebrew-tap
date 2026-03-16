class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.21.3.tar.gz"
  sha256 "1729b6d907cc577702e8e3d3b093ebb79671c683b6e847a330f5de42da3b6271"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1176ec95d5786092d2c66091f4feaaafce981b199e3481d2a63349d143f1881b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fe578396d108aa2751865b3b80296885af8e3230c8381824489dffd329ec238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3aa004521a9cfddfd46a7d0ab23d7ec0e955f1285344e9103fd6d3f219d4301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9805e4895c0f71e19326e1652820d95dee01e8d869fc952036c4ceec3a10455e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29812c094d37653b5d001ba51cba30168604bca3b43c924d24a9388970d2bd87"
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
