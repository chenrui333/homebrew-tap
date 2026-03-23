class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "c697ab84e9588d9cda1a125302ea543c9bf198e07bc95d7ee1ddd3a0dafe70d5"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33a8ef879b04e3afa93fce8325da3819cd8d1fdfdd1b876d6c74694fdfb1cb5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a6f93e425fdb4437418475ecb4186ca3c74e29a1e262f1f2313223458ca63e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf065a3b4d471f7289e59ee9fb7d2ebb7e7c5cfdb517f2ce0562ebfcd78b5b9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63ca35b8e4ab47d0621a61b9583481c354dae6e1d7e167211c8a7198732c68ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9e0c1a9648adaecdc22370e0845b3ab82d0d3401bc497266d97ceec22ecabdc"
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
