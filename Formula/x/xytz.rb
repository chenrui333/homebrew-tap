class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "9edae6fc6dc8af880453352c8d81b8d35070e6a9037caa84b3274217b58c0867"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdec85d52812955bc1c35c2c24c6b0b60c3f27d5f4353cdc7ee818c76d9ffe7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdec85d52812955bc1c35c2c24c6b0b60c3f27d5f4353cdc7ee818c76d9ffe7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdec85d52812955bc1c35c2c24c6b0b60c3f27d5f4353cdc7ee818c76d9ffe7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae02775a5613ee3659e07bf701d33774ce80eb2f53ea6512adb06a833e95a381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2672ce9fac3b467336084c93acab19d05ddbff184121f0e383053f2dd93204b4"
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
