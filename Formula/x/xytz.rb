class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "8cce160be0cc6de3f475f9f7bd9b21992c1d111558cb83e2a13b3b8f06e7282f"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7574a109ea0565e3b31ecb5d71f3d7a667268b510b072f319f5f88954caa5e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7574a109ea0565e3b31ecb5d71f3d7a667268b510b072f319f5f88954caa5e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7574a109ea0565e3b31ecb5d71f3d7a667268b510b072f319f5f88954caa5e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10f6c1960ba8004c15d72cc3b4c0070f0417165146e5ef4e3d6f28d1b7fa9bd5"
    sha256 cellar: :any,                 x86_64_linux:  "773450d2ede3d78e644373f48757f9a6facf35826f5bcf7b407e9f2f4e7dc4d0"
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
