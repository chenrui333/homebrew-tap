class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "6ecb9533d95ca33e6289219924623659e9d7084e2b786ab57d8f64ac59fbc13c"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d9382c000b401025a3430572092862c63344ac56a82c9705ce3d3722b16977b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d9382c000b401025a3430572092862c63344ac56a82c9705ce3d3722b16977b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baa1d8be462808133336f3c2ee07415200d76f2816f15c478fe55f92b39a80f0"
    sha256 cellar: :any,                 x86_64_linux:  "833b584465562596495866dfbbdcec93e304df6bd7c56354de3775d2ff3da340"
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
