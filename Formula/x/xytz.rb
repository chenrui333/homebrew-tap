class Xytz < Formula
  desc "Beautiful TUI YouTube downloader"
  homepage "https://github.com/xdagiz/xytz"
  url "https://github.com/xdagiz/xytz/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "803f58b82aad76f47f95a170fe63cfc9e9a867ad41356c89c65a63f3e42a0bdc"
  license "MIT"
  head "https://github.com/xdagiz/xytz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c9d98bbb2e334a2f2bb195f4cf8f5ea79a863e509e1117efdfe16b8606cf675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c9d98bbb2e334a2f2bb195f4cf8f5ea79a863e509e1117efdfe16b8606cf675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c9d98bbb2e334a2f2bb195f4cf8f5ea79a863e509e1117efdfe16b8606cf675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "256e21398968a5ff829a38dc69f8c30d59676bfef26299887951c48fc633f451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed59c2ca826fd9b2738c37f7dbc3908043b3329b61bca57cd4d82b5ee830ea58"
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
