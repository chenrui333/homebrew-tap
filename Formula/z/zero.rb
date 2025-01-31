class Zero < Formula
  desc "ZeroSSL Certificate Manager - Automated SSL/TLS certificate management"
  homepage "https://github.com/yarlson/zero"
  url "https://github.com/yarlson/zero/archive/refs/tags/1.0.1.tar.gz"
  sha256 "f38e0d126b0bcce46ab649d18472715d0f2bf236b279b34ec581a3ac27360f4a"
  license "MIT"
  head "https://github.com/yarlson/zero.git", branch: "main"

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
