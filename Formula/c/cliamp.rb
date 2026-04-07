class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "931825fb7e1e9439019ac0d486a913e79cb667dcbbb88556485030ccab18eca5"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6977c5e3216ecb2bffb0532e43fbebce54d85ce9bed7b79f45bb24720edcb137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f443cc1652142963e08a5ae8941c8c5e233a700d6dad8daa90514b9cf3625e93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf8e937eb98abae017e3bf71c47057e37cad85e5035158a09b74783ae8a49d19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ddccf03b41efbc5af911c3f822bacac031a2a3c562e76a651a9933c841c731c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46746958a04b8b4c2506b2cc45cf534b6fdd20f06ef55b929902f5b609c99d9"
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
