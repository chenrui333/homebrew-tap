class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.27.6.tar.gz"
  sha256 "bcf58d6c093783cc02e0ec849b1b4719f7fcdd560d864ba005e2eb47e79d51ef"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f5dd7793f47c80ed23ef7ede557c65d200e90a50dc733d33d11b296db14bc5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7214f0b0594866ec6f4613240f83cbe129e06190fe03e5cd268b2a5f3950aa27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4699f735bf77eb211e0b981894a04c7a77209053b8e6f3ff73a96fdf78f2017b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02efd98f3863727944db05f0100fa948f2f40e06f543a9ef313d5016c0e021e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fa438b49038321619068f00cad59c36169b65fbdf90ecc073d99de30a21a587"
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
