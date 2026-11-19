class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "4c547ef99976db373f625248a58024c42b496d077bd8cae5ca07977a745f5657"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5475da2cfc60d5d1e05cc40c10c71c48f58784f9087ed6a02ed0c3685ad699eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5475da2cfc60d5d1e05cc40c10c71c48f58784f9087ed6a02ed0c3685ad699eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27a36ae153b9d8713be5daaf07dc007429fd19a01b3d2c7f5559cde1c2279b2a"
    sha256 cellar: :any,                 x86_64_linux:  "867d7f5fe156192f157e935181432e9351fe9313a087cc917eac4c52fe097f9d"
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
