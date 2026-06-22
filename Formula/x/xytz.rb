class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "4cdf6d96b14de2f08d733f9e873956b3d09ea3541735e5d8166b1ba4f0bf4862"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea07ab5aa52b4c008bcaa6de67f9a5ac215154d42e1e3c3ce71a13c800a99b0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea07ab5aa52b4c008bcaa6de67f9a5ac215154d42e1e3c3ce71a13c800a99b0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea07ab5aa52b4c008bcaa6de67f9a5ac215154d42e1e3c3ce71a13c800a99b0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bc4593698d872eedcb537f8cf192e140b23969183f72747d580a17dd96f9328"
    sha256 cellar: :any,                 x86_64_linux:  "59900f95d39aeddb04eb0dcd4710cdfa2bc8f79948fb8543b4f5e3b82de6e254"
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
