class Zero < Formula
  desc "ZeroSSL Certificate Manager - Automated SSL/TLS certificate management"
  homepage "https://github.com/yarlson/zero"
  url "https://github.com/yarlson/zero/archive/refs/tags/1.1.0.tar.gz"
  sha256 "eae1b4cee2b971d7dca445fe2a65df7b7c30958e505374632e27cfdd23377e4f"
  license "MIT"
  head "https://github.com/yarlson/zero.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4242567a126fdb0b1595961435bd6f3f5537239a2c65e071ade860210768e90c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4242567a126fdb0b1595961435bd6f3f5537239a2c65e071ade860210768e90c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caccd5c83659a04940d481f47cb771b98861a58b5de377c6dd6e965a3fb28400"
    sha256 cellar: :any,                 x86_64_linux:  "719911b35686e5c234d8de2a3bbd9bb70f0c3cfe090e2273e7aaf7bb003e6fd1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/zero"
  end

  test do
    # ==> /opt/homebrew/Cellar/zero/1.0.1/bin/zero -d example.com -e user@example.com
    # 2025/01/30 21:47:26 Starting service. Daily task scheduled at 02:00
    # 2025/01/30 21:47:26 Load existing certificate: read certificate file: ...
    # open certs/example.com.crt: no such file or directory
    # 2025/01/30 21:47:26 Obtaining certificate for example.com
    # 2025/01/30 21:47:26 Starting HTTP server on :80
    # 2025/01/30 21:47:31 Starting HTTP-01 challenge verification...
    # 2025/01/30 21:47:31 Challenge accepted, waiting for verification (timeout: 10 minutes)...
    # 2025/01/30 21:47:31 Waiting for order verification (timeout: 10 minutes)...
    # system bin/"zero", "-d", "example.com", "-e", "user@example.com"

    shell_output("#{bin}/zero -h", 2)
  end
end
