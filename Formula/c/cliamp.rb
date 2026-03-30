class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.31.3.tar.gz"
  sha256 "c3e03b0596086b09ef94aeb38632e9d8a07cf261f6240ba70798016c789c4f3d"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a349a732e72470e70b567eb769b0369eb6bb93e1f13c4b780c1d66de4d2beb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0c0501a448cc422f358f36c4c4d1ddb1473c39185788c5011d0c892c156e0a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aa305dbb539a5a5f898e1bb4c24764d1816e0eec8a136e3063b446db9088874"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b30b19c74a7a73af55d0a784aaec1ca8c914c63d4001796d6f95f28468ccc604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cb5ea5b08cc4f01bdb42fb5c65ee11329816b47a146353e84bf5cad8203286f"
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
