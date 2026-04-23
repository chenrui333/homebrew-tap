class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "7e597cd50ea231c775336a2ed5d4664cf22a18e5d44b2a126b60e3447130dc44"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ce58338c1667b125fbf85e8eb0651d7c517c96c0979192a79ff6fc4e78cd2a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2cd27d800d47d3796aeca0927c7b11c2f1f3c2497a234782431544a482c693d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f5502b21561bc0cced36ebef9ca010f45ce73e129458f3bbd46d2ab6c928dce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d34fb8dc1a43239721ec59dbe9f970e0ed827227a107c1381c4a3aeca05c6a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddf267ac9a9122b6b89ee12ff5139a2096b9522b23ccf064d4ef673031ecd67d"
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
