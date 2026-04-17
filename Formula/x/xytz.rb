class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "9edae6fc6dc8af880453352c8d81b8d35070e6a9037caa84b3274217b58c0867"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d091e04cf4f8adbc577ec3613284a2ec2dde0b7475c87caf7780b9630e7d4581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d091e04cf4f8adbc577ec3613284a2ec2dde0b7475c87caf7780b9630e7d4581"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d091e04cf4f8adbc577ec3613284a2ec2dde0b7475c87caf7780b9630e7d4581"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "181f33571d3c2d35ede6146f339dba68ac17f5e3a681665325c08bd2e5c639b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a92de058ddd87b09c5856a0b4ad03b1cf5478aecc725046f3b4be591e0a5b0"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "yt-dlp"

  def install
    ldflags = "-s -w -X github.com/xdagiz/xytz/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Usage:", shell_output("#{bin/"xytz"} --help")
  end
end
