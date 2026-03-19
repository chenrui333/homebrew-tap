class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "49f52969856487417ceed4d8e8088992cf7cf8ba59a5ed927d75322709b5361b"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a60d86c21b9611bccfd1e48acb694783ba830f3d4b3d5712cb1c9a921e75dcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a01c49c43fb1906778692342f1fc27ab7085821f75ba31cec9f0cf5995de99f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b92078d73c192526dff206c099d8f7ab6b030e725a640ccc8428aab47e660e4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13b26fe546a9c1be239403dbfc349f3c600e60270907d31097bedc0436284698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59fba598b587d6c1c03b283712d001c620b98193eab6ff6ca253d755847c1de3"
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
