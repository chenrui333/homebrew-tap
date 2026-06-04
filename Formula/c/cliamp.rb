class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "3afff2a37cd6988aa1eab2614d6dd0c032fe5fd0ec95488a772b58c7e8edf076"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f12e5df34712717c0ff9f8c7a05a3e6b12eb8110455f09f52b613b86bbdc348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aad89b71dfa5bbb43d7278925e2ded4a9efae388a1f8f8aa996f34b7ad062925"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30822b490b99f4e7a1b5c1a09003dd45129970075c301e4872140a0825ad5b2f"
    sha256 cellar: :any,                 arm64_linux:   "394c7775feb846a422f022ee909adf375ff8c14123e123a352ebf8d03de242e4"
    sha256 cellar: :any,                 x86_64_linux:  "39634521b4d774ac0820e017511398a1979c2f9c52a0495c3eded874c2774e8e"
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
