class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "2cd8108f5df6a496eda9abf3969b8be4b6c7d1490f224372ae4492829563c417"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b3f12e3bf608401ed3736f1ecd8efc23585d1a18224824e82f3cf20cb098244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c1dc30e8d9eeab57e3e7cd9292d36c5d72da1b7208d55ce266925bbc214c94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f67de5464d7d03da4fa7932e45b27a6c9228a21ffadec6510e31583a7fba99ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "889a219508ec79647087679b7a321089d63adfc194782ea55039fc3b0d47fa72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea22beac4b662c51269002ee785d28576d34c62eb8037a37dc03c0e1c71366f"
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
