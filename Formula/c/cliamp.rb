class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.63.2.tar.gz"
  sha256 "968ff98c1e49bae8a0ce63acf5c77a9621ef70756a048e3df5e79454b82a9eef"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9b4359baf53674e8795a2f1b5f8433df72ed356bb83273a0b7431cfe5c111c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40ffda08b84bb4f27736d711b869df9194b381316f6f6a1878b8d64b40f34e11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f556b6f39a0749df389d604461aed144463f05355e2a05353b374d14753b1de"
    sha256 cellar: :any,                 arm64_linux:   "8cea907b394116f572fd9c3e55faf3de5fcfd53f68af1225996ce3ae747262c1"
    sha256 cellar: :any,                 x86_64_linux:  "556240b6bb9db2328843f1dbda9dfc65353e9006333137e6cb7eb5a3e9ca0678"
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
