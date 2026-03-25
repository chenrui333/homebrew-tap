class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.27.8.tar.gz"
  sha256 "7858644bd59507a87790faccf5e583ad9847d3a47a81a34edb2ed50912f83e4e"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65c0921c8766c9d4d66b30c43d69756cb68fb9ad3c0ec8defaf16b7783137735"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4afe66c037e89f04ecbdaf6662d04221f6d6878fca0a324b79ddf2de3b12d1cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d12d075b80e3783e91f1b4491e6d929a44c7b729facfdd74f10634b3f62205e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63515ac51ee84fa53894897eda7a3c673f36ddfc9d816516d94298af3937f1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2989629531d4e2596a062f6729eb56bb89a277b83a46213dfef69613cee9c49"
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
