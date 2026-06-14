class Tetrigo < Formula
  desc "Play Tetris in your terminal"
  homepage "https://github.com/Broderick-Westrope/tetrigo"
  url "https://github.com/Broderick-Westrope/tetrigo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "0347e2739e6fd7fc37667eb8873030f700d26e824d124d73ff8eb49c910946a8"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4540f32e1afc80d551d8add2c2c3c3843124812d93b6c5f87f21c424b8573db8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34eaa94e6c9104a1e7beebaa37334c03d59c84332b71bfdbbb1278c80a6b28f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd4c7521fa7034204ed4de283ff0fe6547f7ef50017572792dc51d612889f5c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78745d0227d71c0d842b7be13da5d57df0deefda4be7721d67a87a57dc17cc40"
    sha256 cellar: :any,                 x86_64_linux:  "95e2e72e3c4785222332292489b6f593b06a74d1d6ff6961093d785b7e069374"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tetrigo"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"tetrigo", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
