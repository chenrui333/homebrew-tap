class Herald < Formula
  desc "Terminal email and calendar client"
  homepage "https://github.com/herald-email/herald-mail-app"
  url "https://github.com/herald-email/herald-mail-app/archive/refs/tags/v0.11.0-beta.1.tar.gz"
  sha256 "552f9197868b72dc9062fec8ea5c6d30bb0508e6ca8d4a4364002eca1d4d871d"
  license "FSL-1.1-ALv2"
  head "https://github.com/herald-email/herald-mail-app.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
    strategy :github_tags
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "601ee7c47af8e6d0cead6578edb38aadefcf7422404cea7fe95a5e86ad53908b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cb59a731cf8747fae4559ccb1cf5e86df2591504a6e74a0b95e42d946be6081"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2e80235bf89dc286826b9975f3c7959525a38816a1cd9fa33199bf5253a6df0"
    sha256 cellar: :any,                 arm64_linux:   "1e6062aff392ab608fd94f3a0247bb0be999471c625de1e3bcac5f19a34fa539"
    sha256 cellar: :any,                 x86_64_linux:  "e0650f04daa9cddc23225b7a88c9b7088941186919e77e74cd61b4f430aa5612"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # go-sqlite3 requires cgo on every supported platform.
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-X github.com/herald-email/herald-mail-app/internal/version.Version=#{version}"
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
