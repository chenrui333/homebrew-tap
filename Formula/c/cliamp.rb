class Cliamp < Formula
  desc "Retro terminal music player inspired by Winamp"
  homepage "https://www.cliamp.stream"
  url "https://github.com/bjarneo/cliamp/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "6cc38f4170359a80b7b51ac70dd3100552c911bc55eff2504ecce6c81db1c2ea"
  license "MIT"
  head "https://github.com/bjarneo/cliamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a77ea3b83c7ab4cd5b1eaceba752bcce547bc1c14f372a083ecf8769f13b5c4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "129b28a98056f01933656010759b8bdeeeacb62197c17e3bc8cb111db1f659b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb5946d73a83fee423af1c399a8add877fdaff7abaac4c35581e95db6ba5f2be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78844df6bfa2e35cb99f16aa4f40358bcccd28fd7b8ea39be077dda69925c33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca582b0a159b467b51d3488523f396d10ea2f2cdb2b0104c9ae3d7a941f6f52"
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
