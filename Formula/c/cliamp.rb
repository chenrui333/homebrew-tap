class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "706656e8e50f20936454f4e3707f29f8cdec07b8bcfb31dc75f3c8eaea3a3232"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "592f49e2bad5330d0d8fd1ac1caedd9ca67272a190608a73d797721bb280d2c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52154b2a6e1f1d34005cdfc39e8135f078aa0234520f1eef77b662c6c694582e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "308c60a00297a1da2ac01411c5900113fa5fc85ec017ff8aae3a0cefb862810e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79e7bffbc23d6e3e064334260eb01e9fccdf438e377b713e8004450a419b0a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b2a02796cc0b40670a05d7a989adcccb51c84ac003f46ae35379ec8eb76aeb"
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
