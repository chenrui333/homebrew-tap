class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "dc93679c8f94679d4dca0c22cc9e2d61d62e9ac013c11d9a274587fb98289781"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18208260cde30560730956cf89770415e3d9b82604d0c432ea846eeeabcd4faf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa58c88136174267c1a72f02d67cbf94ecd328f80952ad857055120cd7d6193f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc560bdd40458682b83d548bb24650bf9911e4e5c5dc02d25fe5b23b408194ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c3e01ad1a4efe88c17e5093ecc115f59ba7966fe7d3fcf46d84bd02ae5abbaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7505e8184244a7deaff15a6bc477c8b3d3a9d82668c93118585ae774e0a391"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "yt-dlp"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"cliamp"} --version")
    output = shell_output("#{bin/"cliamp"} search 2>&1", 1)
    assert_match "search requires a query string", output
  end
end
