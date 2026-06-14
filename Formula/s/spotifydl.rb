class Spotifydl < Formula
  desc "Download music from Spotify with complete album art and metadata"
  homepage "https://github.com/BharatKalluri/spotifydl"
  url "https://github.com/BharatKalluri/spotifydl/archive/refs/tags/0.1.1.tar.gz"
  sha256 "ece91673c8cd2d8b6cd89610cbfdf6e1ef4dc1e15fae8aa120e9d1acb8fbfbb9"
  license "Apache-2.0"
  head "https://github.com/BharatKalluri/spotifydl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "865182b4b3b97cb5b706c0322702383f18da895baf0c378dbbb985ae236a60b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "865182b4b3b97cb5b706c0322702383f18da895baf0c378dbbb985ae236a60b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "865182b4b3b97cb5b706c0322702383f18da895baf0c378dbbb985ae236a60b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "962d46ff46bdaf6fe509773cf40b9c2bdd8dfd12c93268f05536820f37398de8"
    sha256 cellar: :any,                 x86_64_linux:  "1fe1b25c1734ba13cd7f28cd93f0328e565f3c073d00176a12f2370a92bcf442"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/spotifydl --not-a-real-option 2>&1", 1)
    assert_match "unknown flag: --not-a-real-option", output
  end
end
