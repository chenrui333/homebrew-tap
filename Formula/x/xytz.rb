class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "8cce160be0cc6de3f475f9f7bd9b21992c1d111558cb83e2a13b3b8f06e7282f"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e857c27483c0a874a1ababf23544b936deed6fe432d3a27442611c21acd4a183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e857c27483c0a874a1ababf23544b936deed6fe432d3a27442611c21acd4a183"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e857c27483c0a874a1ababf23544b936deed6fe432d3a27442611c21acd4a183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a33aeeaf69817bef9951aedede92bea3c5bff8191ea8f30f8fcd456a555410c4"
    sha256 cellar: :any,                 x86_64_linux:  "70fb8f9a397a3b51a33e7690c3f7d8a3587bc4391548ebc8457aaa571c9dbf32"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "yt-dlp"

  def install
    ldflags = "-s -w -X github.com/xdagiz/xytz/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"xytz"} --version")
    output = shell_output("#{bin/"xytz"} --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
