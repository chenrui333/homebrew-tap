class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "168690d8d6b7df298de579bd62ea4312f1a662499ba636cd8b2d8f2853a7fc67"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baf78cba1be41cc3add1c05fd12e4b713aca4dcfec128dff1d81b85a988d73f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "367a1be995487252616d8d987e76e7e155f0445da30baeb3cc3c8869779293c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0add85e78af726702cae5b56d2188e8d340fbc3b4e951afb61a7ca1e9072e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc5a68e78c965988b9250f9de44831d612d637535072bc8ef3b0359b05206f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b5022c38417926cbe010ce72595bb28a4e8183d359f28e419639e8fbf157ca9"
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
