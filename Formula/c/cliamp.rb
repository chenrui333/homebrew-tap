class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "0c799d48998f393ac12e11612c6cc74e3625656ce36e33d5e693a92bd895c547"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "010d8ac720ca25052b639dfc8fc82f3f37222a4155333572e3a32efede3813ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4618969a4abc0b71647966adc542241d52d0730b0185b5eb8f178de79f75d09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "141b4c36f402ee63b91204a736a0e18ad32c145100c2ecf7d3fb2f4367bc3e48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd6b99dadac0f24b0b93ff01252cc438bfc3ab4d87b2751a48df2c66e8ec1791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e197439dc692af539b2947163e40ab10895ead3de56de395ce74eb1f486c706"
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
