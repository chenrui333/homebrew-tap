class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "cb382e6b961f26aa7fcf7363513a02c24e09eae91aaaadeb80e04665fa280a67"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f150862748fa72546a32e57cd9936ad8f472611ffe205634d05a24461d3ed231"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9ff1135dadf43eadfea470f5e62a0ebca7fb1a041d8a7f641d74878c18eebc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f26dd3536ad8685a5c6199d7e0fce03f790562c5a982c2bcf9ab48dea755bef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9a0d83205c861b40d11891f06bf4b43c19c050e0c8e532d518d3d2f7d428085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeeaa44ca2c21856c851a4aca12a6b652b97af66c2932272e9336d156df6bae1"
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
