class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.33.9.tar.gz"
  sha256 "0e5bd9714c611aa1acae6e4e5d1559c30cad4af0adead649c69248609e082d3d"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "824bf3676242d917cd5c22622a63fadb53669ca5681ec451144aa162a6d527ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d51e652c151576d2140799ff5824d09784f1d9fffa3ce4b4cf968a76b918792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e545d037a8546355191ec1201f327d419eb2b2be24278976e534c599c005b559"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a225f10b19e5aebb9cbcfc3bfcc716f6112c864e42cc3e11fccebc333a730514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0409bf46432c2c0616e95ee64d9552a9c2f0da14ce2fe7965104a6bd4c2f38c7"
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
