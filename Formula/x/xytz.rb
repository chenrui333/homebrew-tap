class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "cb3cffe738c0b36e4608840ed6e20e68f85f311525266fd218fb143b881a133d"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aaff18b9f434c3005046852dfd20ea35c80e87bd0def2dcaf9afcb1ab9509cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aaff18b9f434c3005046852dfd20ea35c80e87bd0def2dcaf9afcb1ab9509cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aaff18b9f434c3005046852dfd20ea35c80e87bd0def2dcaf9afcb1ab9509cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a8a8b6dee1770af66f27877b97c386c94198c3d6437c602ab73ead40407a77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cca43f6231f18ac10d3b89f5a0f59cd56eb6cf8b0bc6b88767275a06ab83afcd"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "yt-dlp"

  def install
    ldflags = "-s -w -X github.com/xdagiz/xytz/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["HOME"] = testpath
    ENV["XDG_CONFIG_HOME"] = testpath/".config"

    assert_match "Usage:", shell_output("#{bin}/xytz --help")

    config = testpath/".config/xytz/config.yaml"
    assert_path_exists config
    assert_match "search_limit:", config.read
  end
end
