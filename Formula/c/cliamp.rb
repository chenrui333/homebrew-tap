class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "5d56a493972b9008d4be637e46df00a02de83a5b98327c391714ceba0961657f"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c12176630ac328e748f374989c48b11569b6162b5dd3f5769af7a5ba737c8da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b80ed57d1dd8fe9b78fe3662367f00b97d5a7aac6a3492e771ddaadddd630047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2178090b78080ad4ca122410d762e2249d72b341dea50dc2675a98c5f623e9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "746b0dee1bb692e9c04b4df45a46173597bca72ca2ba4abd66b533c8dff7851e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a19df723e41f960656d817db54a729d1510e37dbcce2f3b2f25dfe53e38542"
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
