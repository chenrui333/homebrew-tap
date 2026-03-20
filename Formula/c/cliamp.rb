class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "4f447792ef10f426e7dba26bc0882b0b9c50bb54e01573c30ebcc9858e87f5fa"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b06d8ce4448e7a772e1751d82829475246c2aa59abb72789e90d8f1a2debbbe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dd8725ec133e89b25edfb6c64d08477a3bdacf582745d2198eb2c9a7a1b1d32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f7fb02ee159e016e866f2b98a2ab91eafa4528c3317f9c1b0f243d5b015a9b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22f6f80b95615397a7db96d3f7391359d1a757380a00aaa618124b70cb34cfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7393f03dd544d15de7e24799d0f50f8b88d3bbf3ab80f4b100caf8b8c2a91950"
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
