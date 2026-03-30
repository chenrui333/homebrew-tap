class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.31.5.tar.gz"
  sha256 "196cd573a67613335c180bbcbec7f320642d347048097e7004313921cd19d7e8"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b659a363791e709a3571dc2a767da5a960876271e53fa331bb1ee047925b26ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb7a34414dd53e40996ed7fe6157cc9e782a477d81c108ecd65e7fe25ea2fabb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c8954f55e74a8867d59078a4e894f2a00e696c9394797b49d39428f663ff769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d53be26dd9f30b5897fbe7b140c4918cdb7042fe8180cbf81dbeb5f0e880347c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ec6a6b6c0c06f3db35ed02c28366a33c01cf658e4ad2bd0dcb980acaa6641c2"
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
