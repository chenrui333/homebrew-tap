class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "5cdca36b6eed0934d97d4879ad8458950ec05d232533fba9c5cf418618a0f93e"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c0ded172692a6a508517ac55d5c873b7f739a564292338bc663283d2f9e91f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee0703b968e783225f7b603f8b9bc5fed2cb9776415219e688f02142d845eab6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea08194bef5d23a7bbd30b2238caca576c76092631c463f8ccd8bfd5a07db0e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4fb74f486bb3b61ec5dbdbd955cfaa2997ba363c23521a1ccc0437b0903fb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34d6882d35c34c91190a9871a9860bd780e87a6ea8cbd7ff819ed239ba03aef8"
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
