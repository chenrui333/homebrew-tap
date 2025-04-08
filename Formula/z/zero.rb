class Zero < Formula
  desc "ZeroSSL Certificate Manager - Automated SSL/TLS certificate management"
  homepage "https://github.com/yarlson/zero"
  url "https://github.com/yarlson/zero/archive/refs/tags/1.1.0.tar.gz"
  sha256 "eae1b4cee2b971d7dca445fe2a65df7b7c30958e505374632e27cfdd23377e4f"
  license "MIT"
  head "https://github.com/yarlson/zero.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff2510f081aac78115f82d340c5872578e04538ec3e4b19db363dfdd450a6199"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14eb4a6628d5a56c4f99b7de0c38ee4b7562c2c75bd54e9a1cbfeebbc491d4e4"
    sha256 cellar: :any_skip_relocation, ventura:       "67f5841ccb716a21bd1b94984b951b53e6d8403a6b00ba46ca9ec19c5020d5f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1035dd593c1a4fc8f0abfb7d5a1358ae740b7d52443297d131431d42357334e"
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
