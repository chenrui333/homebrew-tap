class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "fb5e43513b71287cd1db39403a293436b38db2ffa73fcd820a34ba3a73d2523e"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f18a60ae282d2baffe76f400bc195436d8441706973521b643cdc57f23bab717"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc59695f4c38974d0d640afb56b0c72d5dbbaa696753b45f09b7dbc8308e34cd"
    sha256 cellar: :any,                 arm64_linux:   "9e147978591445db84356d5d143ffc139ba5c994cb4d30e718aa50f8af1fb665"
    sha256 cellar: :any,                 x86_64_linux:  "1e5680b542901482b6c188b30c572341ff7dc3ba9e7c45c4c6fa3f600cce77fd"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "yt-dlp"

  on_linux do
    depends_on "alsa-lib"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"cliamp"} --version")
    assert_match "No plugins installed.", shell_output("#{bin/"cliamp"} plugins list")
  end
end
