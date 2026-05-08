class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.47.2.tar.gz"
  sha256 "d59996b6157c6cc855bdfc52355edde75a56ba28d1665f5d32c84f07f716eb09"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0fbfb22c3a5f67a72af4b42ea9edea1841077df39ebf88c5dc1d80e284abc5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da6fe8a0e504436022a4ed9375622eb58de2f81b66cff525bf12aae42c4cd219"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ffe132436a45b039f893b39c4d33ed9cbeaac60f4b49db5363a4d19d09e708"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90b4fa2103b90cc07eda939aa93fa1cbe25b36abc4e3791ea3570a0c35438794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd10df0b1555d3006d89867af0a10e1aded1a7b2fd3d6b9a7729527fd329509f"
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
