class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.31.5.tar.gz"
  sha256 "196cd573a67613335c180bbcbec7f320642d347048097e7004313921cd19d7e8"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ce49ce96f672f7915ea6d5470cc18e4f83984fd58a40d4f090fe348a7e7ff67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a02ba53c5d7c3ef48955891d762a37bb6b91a521cb3ef55b349519b03e64ba75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ee9d747f8fcafbe36a618d791c8d438192feb68e05352d3ffc1ca3b45fe091a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4a443f472fead2acd8b1f9f1111bf3b177e9279da88c25d0ce5c94abfbe80ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79250f898eb0fc58197b871203616067a74b9e26565b3756a330cadd4073d251"
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
