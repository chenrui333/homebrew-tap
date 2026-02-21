class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "4db513109e87419af5a915e97daa5303ba8e1394eafc7211be24840647bdc744"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

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
