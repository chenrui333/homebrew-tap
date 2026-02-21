class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "4db513109e87419af5a915e97daa5303ba8e1394eafc7211be24840647bdc744"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "010bf94041ad06540988d5f3f9839159a4da02b5fe02e14e4ebfdaf15fdf85ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "010bf94041ad06540988d5f3f9839159a4da02b5fe02e14e4ebfdaf15fdf85ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "010bf94041ad06540988d5f3f9839159a4da02b5fe02e14e4ebfdaf15fdf85ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b1e7aa3266e6c11d15c4937e6c5dfd6fabbbb5bab7a82e792ed28779823c3b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d66389a541a22c37dfd27093d209c2c12571e93afa4a3317b49760af27788db"
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
