class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "cb382e6b961f26aa7fcf7363513a02c24e09eae91aaaadeb80e04665fa280a67"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a60ebd138e7f3883ad11e0ae6b4d369800d8c96c736830ad4ed3342e0a1bd53d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80a44739c92224c1c7212d998f8db7cbe35f678773e8f69dff85d3dd3789268f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "958ed1d9267b474c64c82d44532e3b519604e2f8c0c00fa6da79e9b318fef4b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec89b08293e74906d2e02bd752268486427016a1293de1692976e7defdb32561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "761ba13a9a734baa14d72f74089443f80d2ec729fd6c2fc5a2114b83f032c4fa"
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
