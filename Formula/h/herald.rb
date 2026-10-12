class Herald < Formula
  desc "Terminal email and calendar client"
  homepage "https://github.com/herald-email/herald-mail-app"
  url "https://github.com/herald-email/herald-mail-app/archive/refs/tags/v0.8.0-beta.1.tar.gz"
  sha256 "fcbf0b3b3c438489a2f71b2b1a8378ec8068abff4017f6347f91bcb49a47b51b"
  license "FSL-1.1-ALv2"
  head "https://github.com/herald-email/herald-mail-app.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
    strategy :github_tags
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21a54dd59de0887fc215a79a5c3c3b159e1fd30a728d096644bff90b9e2f5ff9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b09ac4345749f5c1128d877a26aeaaa27ddf5420054d3a7e77aff164e7bdb7a3"
    sha256 cellar: :any,                 arm64_linux:   "56ecd770560abbf3bfcc1080a1f38019ac762c69884d872be9cd005cd59954e5"
    sha256 cellar: :any,                 x86_64_linux:  "1d28c33b7b3d7c0c30b7d9dff6a12f09510be0ee6c70b502fdd920fefceeb581"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # go-sqlite3 requires cgo on every supported platform.
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X github.com/herald-email/herald-mail-app/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/herald"
  end

  service do
    run [opt_bin/"herald", "serve"]
    log_path var/"log/herald.log"
    error_log_path var/"log/herald.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/herald --version")
    output = shell_output("#{bin}/herald serve --config #{testpath}/missing.yaml 2>&1", 1)
    assert_match "Failed to load config", output
  end
end
