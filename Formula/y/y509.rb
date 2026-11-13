class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "1c8d06b5b6255e7ad5f3b826ddd1d636fd2ac718b2411127a82864fda3acc982"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "051a3f7d92f71dc89fa606bce55add4c505d153ee7bf5a06d9c18eaa2a58c4da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "051a3f7d92f71dc89fa606bce55add4c505d153ee7bf5a06d9c18eaa2a58c4da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00510d1e746142d429970839d7883560b645b1c2cf5394d6b6d1a460bd8dc3fa"
    sha256 cellar: :any,                 x86_64_linux:  "51cd4a93186147bc39b95a38999e5c51b629502dfbd66c13f5a2a831edd85017"
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
