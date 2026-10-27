class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "a881e5ed6694426e0d36d8be6844c037084f270c2bc7482da1b315a9eddb7a0b"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2348fe4b0dbf930f9af08c2fac3ef45b69718f9c10ba00f47a9ac19addfe62a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2348fe4b0dbf930f9af08c2fac3ef45b69718f9c10ba00f47a9ac19addfe62a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddddc62e7843d551452f122654053b57254d015f6f2ce8e1d742316d89b056f6"
    sha256 cellar: :any,                 x86_64_linux:  "112581210087e91bf96bd3c3f129853f9ce8c3e559e9fe2dbccc9431ac1dc64e"
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
