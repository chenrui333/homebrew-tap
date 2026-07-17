class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "792956d4d57fc9297b6e2c30f6930df2bf30b3d4dc3576b9712bd803a214b41c"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db1baae2307ef2d24c143ce613ce2237669af83caf6858a55f355ee4861428c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b0cab42001928a3c82a3c29de9cdc78ac45897f6b63c7f84ef98bf718e8dce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33c4f299dddf4a511d79b1bfe846463c72f2711da150c3ded26c9b3e9d7a06ad"
    sha256 cellar: :any,                 arm64_linux:   "dfdfee8529486301276cc5d276e354fff11f91f8f1d072dc93024e6687c9b557"
    sha256 cellar: :any,                 x86_64_linux:  "33189fe1595b8a4483ca39f4077686aee99eb80b3ee348cd65378032bb99cc78"
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
