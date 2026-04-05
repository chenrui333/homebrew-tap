class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "c81e1aecdbd16802c6d6172b8a31a855e8a6341604866af2ea0bcecff5047c45"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1c2bde3ec72a60c3b84790519ff98252390c08262c101a4ab423d42ea156c09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a7b3291315b7052248f1f37922267b5bf39ca332aa555332290371a769238a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "945697e120f38d062e08df78c980414c043a24d45314e3c053a50538abeca218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a1ea389f943e6cd4fe392f25c6b4c87a07581d607326cad73fa624ba9ce7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecf7cafe8525b393f13cb3452dbb554d2ca1c12efa7677c8819cfb9eb125a761"
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
