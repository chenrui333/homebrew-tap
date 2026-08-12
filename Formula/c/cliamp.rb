class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.63.1.tar.gz"
  sha256 "e8edb908b0bef026012d1352b834a51f4c027647c82d521fc6329e54cbc9cc85"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9be5181cecb1f250070da53c847c8684eb770027d492724ed8043b247445ac4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80bfa6c20d9c9ff9279b3f10ff77466895228519abb653e3bb9c1f2cdc2e5189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8702d931d951d1da1a97a0599f7b5e25eb1f67a003260579fbe154df6247f93"
    sha256 cellar: :any,                 arm64_linux:   "56d0e10456e092bf0e364558da9558131cef2cadf073378363851c4e0bdb643e"
    sha256 cellar: :any,                 x86_64_linux:  "d4b9b0a3197563831dfca026c4cf3312e263c4df28528b0b0a9ef689462f1934"
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
