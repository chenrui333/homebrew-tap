class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.44.2.tar.gz"
  sha256 "896f51c5d2a026482b130e8fc2eababfa31539a109b262571d60acfabdc19cfd"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbd6b62f72ed57140f4de514e62ade1a3f2409435c96d86512cee370999a71f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16b9aeb80485ce23bd3a7d1e98ca4e75cfe930e9e1658645ed765cbced497240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da8dde9daedf58b808df9537b999664b59c196ff45e881f11e811052f29436d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d78845d1c400051ac602750b64d97cf3e379271cd3dcb4870d763ac83cc2340e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5fef3040639a35114b5bfa7d3f217f875090c38e183ec7b0df7c69c7fac49aa"
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
