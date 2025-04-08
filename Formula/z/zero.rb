class Zero < Formula
  desc "ZeroSSL Certificate Manager - Automated SSL/TLS certificate management"
  homepage "https://github.com/yarlson/zero"
  url "https://github.com/yarlson/zero/archive/refs/tags/1.1.0.tar.gz"
  sha256 "eae1b4cee2b971d7dca445fe2a65df7b7c30958e505374632e27cfdd23377e4f"
  license "MIT"
  head "https://github.com/yarlson/zero.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32183758e7fbf7b04ae2b51fe7f602af04c92cdfd5673ffce5da7b450f401730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "289895442480949ca8cc47709e164773e1e2cfd56d3c7d8df22c0b8054506a63"
    sha256 cellar: :any_skip_relocation, ventura:       "7160398fb07dc3243926f688c717186ca64707cc6ba82d13775b6fb316d59137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db801f1991e5e278cc4462cd824147902b6fa3d303a0e5b6fdffc5e27f2a6762"
  end

  depends_on "go" => :build

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
