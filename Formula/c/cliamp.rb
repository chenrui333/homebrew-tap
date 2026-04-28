class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "d54f294d878403a566270f656fb9ac5d0b15a6e4dbe77cfb67d5bfa96f2d4c66"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "820fbba2a605810039ac410744e299283bb3da9e20f0d9060bbb5d988ccd3798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e59ec952238d870e88483fde0c5f203624d3dbb6377b34e75b82bc37a56057da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ba12d2c5d0e2989ddca364e90201c97e78867287368862fdf91f7e2bde8d70b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0444abbc0630e8966d096d06f7bad7e96060312aa9d15c20be7994ef5b4a4359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e583902e9d5811f8e2d340c288139f41bc7834441b680fc5ac8cd82c0c2fdfe7"
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
