class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "2c48bd2925189660d884e290a60ec9db823ef39ee31a3fd0aecc4c3036f69ed9"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbc44906f8bd67f6453428fa4cc181908b407030e3f15337d425e48d439f8c3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbc44906f8bd67f6453428fa4cc181908b407030e3f15337d425e48d439f8c3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ded9d7afef6e2bf3bbdabe8cd27a86c801ceff03d827d5640c5f31b5073694f6"
    sha256 cellar: :any,                 x86_64_linux:  "a986eddc718779dcdeab00254ec5e6a83ee93c2860f676fe3a1bfc8e58678f93"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "yt-dlp"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
