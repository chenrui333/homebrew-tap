class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "c697ab84e9588d9cda1a125302ea543c9bf198e07bc95d7ee1ddd3a0dafe70d5"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c512ce0e285f7622d0d2ce2a8a349fb73af0b79781e9f02e8a9538f54351e89d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc1ab357dc58687ad3bee0cf05c032824ac85842800c28aa025de01cc5c5c919"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a594945833cce81783dc4a84114ba6eed6e81e0dc6922870bd512c7f300326d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da2d5b5d7861a7762a87e978424c9437cfc7ecc5a9929aab787dd3724b3775b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0e583d21eec43af9fb5e16cea29e83a2b1298db0f7076a703d97795d87959b5"
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
