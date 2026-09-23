class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "fec70220f5f65b69422a791a22610da539bbdbdc341c42de29de397483792d73"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "796a08aaf078053644db52bfecc75b9bbacdd6edf86eeed15f3e340c4ae21026"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "796a08aaf078053644db52bfecc75b9bbacdd6edf86eeed15f3e340c4ae21026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "796a08aaf078053644db52bfecc75b9bbacdd6edf86eeed15f3e340c4ae21026"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89252ebbf569a1f8b5b8bed694f822bd1461616616237f8db88f423325d2c8ca"
    sha256 cellar: :any,                 x86_64_linux:  "74db61b1589e105e4000e0c5d180d2aa3f6d1f325342b3fab2d75b019cd1a6c9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kanywst/y509/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/y509"
    generate_completions_from_executable(bin/"y509", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/y509 --version")
    (testpath/"invalid.pem").write("not a certificate\n")
    output = shell_output("#{bin}/y509 --input #{testpath}/invalid.pem 2>&1", 1)
    assert_match "certificate", output
  end
end
