class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "1c8d06b5b6255e7ad5f3b826ddd1d636fd2ac718b2411127a82864fda3acc982"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d27c24b069bda120c11cd818a87d068e9afde179777ba073d470818f9fecaa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d27c24b069bda120c11cd818a87d068e9afde179777ba073d470818f9fecaa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2e06604dae0a0ea40c35b5fae2bfd3027892c91afff89681d8b70d540f23ca3"
    sha256 cellar: :any,                 x86_64_linux:  "9b09323b626b2b2f167b59d3a02760b02acbf6130e29f648c311d943620e45e9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/kanywst/y509/internal/version.Version=#{version}"
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
