class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.57.2.tar.gz"
  sha256 "fcabbbb8ba35fd7a9054fb10417c87ac4561fca377b9d6e98f7f6c1770cfe664"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff29635c84fe8a82399cac1ac05ae9c60bd71eed8cba4ec01cd35159530933d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89319237ca201a93b366f57589c79b2098a3178dd4dec84cae18d978c343bafb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4df57a787728cb48522a2213218af4c7f46523335f43243c0ecd01ff7773adaa"
    sha256 cellar: :any,                 arm64_linux:   "a05fba5f703b7607501592a7e2634b10f9a01a8dce6e51b516f43fcc9769c5f1"
    sha256 cellar: :any,                 x86_64_linux:  "1102df46e09618eba8df96aae3c42a311876ecb2eae781a37ce31c46c9740d17"
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
