class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "0777fbb7172e73818f67ebcc4669c0a2c9cfdbeac88a357e572d8c07191e3e34"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b3b58b1a2430cc614f79b23c8224c1f78db8cd9cb611802ebe6a57e004f073c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b3b58b1a2430cc614f79b23c8224c1f78db8cd9cb611802ebe6a57e004f073c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc074c475e802df0665052b9f95f5573e40410bf7fd7eae7d6344975f1b3c1a9"
    sha256 cellar: :any,                 x86_64_linux:  "3f43667bfa4aa98f81c39d22d2912a12d44b9a252cf92cfbd45fa88bd0380ea0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
