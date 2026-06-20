class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "46f420a26b4477b5e0c37441531afcb202321eea924acf3fca0fdf55ff8d4d29"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d78e6ef36d85604eb9e4591689ea71191dd684aa532c413b98a37ac8192a6126"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d78e6ef36d85604eb9e4591689ea71191dd684aa532c413b98a37ac8192a6126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d78e6ef36d85604eb9e4591689ea71191dd684aa532c413b98a37ac8192a6126"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "693e43a4256c2fa368c8f8fa885272ddb699221236d9cd127bbf686c90abe967"
    sha256 cellar: :any,                 x86_64_linux:  "c44480b3e8535d1fbdb0c3ddd869c5347e19153ad2ac20f0e94778377a2b5ff7"
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
