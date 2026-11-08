class Herald < Formula
  desc "Terminal email and calendar client"
  homepage "https://github.com/herald-email/herald-mail-app"
  url "https://github.com/herald-email/herald-mail-app/archive/refs/tags/v0.10.0-beta.1.tar.gz"
  sha256 "ccd9e6f9355ed088b6981387d65160b1ad4c77349469b644d251e73d74521649"
  license "FSL-1.1-ALv2"
  head "https://github.com/herald-email/herald-mail-app.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
    strategy :github_tags
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c19df8289e6ba3883dfd8b22f0f5921069e935071f830e574ef2ae595f3ca85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8da2d7f12b2ad8d84997b9a674ada0031abfd87461aa9722fbf96b04e50b968e"
    sha256 cellar: :any,                 arm64_linux:   "67b240e13db821ee40e10d9cc668b7af72218af8deae9b3d9f84bc65352def93"
    sha256 cellar: :any,                 x86_64_linux:  "4a4a173941b71cb5482c70537f43b3b2e4641e64f40bf20083baf995a3008201"
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
