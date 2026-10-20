class Pphack < Formula
  desc "Client-Side Prototype Pollution Scanner"
  homepage "https://github.com/edoardottt/pphack"
  url "https://github.com/edoardottt/pphack/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "cc4da17a45873942a00eb5f499bb8c1c3c1124c084d9eee8d6133c1ba306630d"
  license "MIT"
  head "https://github.com/edoardottt/pphack.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f01f05e2ccbae584f50917e32ce2250095f13fbd0e3a56cd54292d00b3f2d7da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e14e3954ee72da2948234d993de731cabf15f339393cb7ac44f6d57ac76152b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c681dfeeacefc11f1fd9b75c95819f8190b233023246aace53334189f11d627"
    sha256 cellar: :any,                 x86_64_linux:  "6e70df75ec25367d952e3b1326c5dd81e7b6b36c7ffce3f1a3b28d8e38a7fe83"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pphack"
  end

  test do
    # FIXME: Upstream does not expose a version command; its error banner includes the version.
    output = shell_output("#{bin}/pphack -u https://example.invalid -c 0 2>&1", 1)
    assert_match version.to_s, output
    assert_match "concurrency: must be positive", output
  end
end
