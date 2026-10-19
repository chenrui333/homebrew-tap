class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "cffe4387453922386e5f0d285145ec4fcca042b2e72c659fc8f38c62027ab75f"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1388f9538d998e82c6b03200c46bf22cc9f47ede15034638903cc632d1388b4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1388f9538d998e82c6b03200c46bf22cc9f47ede15034638903cc632d1388b4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4201b60310fb529ef39f4cf74bcad6d309ea8427f4aca13cd1e9c16af84c1ab"
    sha256 cellar: :any,                 x86_64_linux:  "469f7a9b94504414070de1aff32ec9c26336afb416c777c9f5d4068fdb60aaa4"
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
