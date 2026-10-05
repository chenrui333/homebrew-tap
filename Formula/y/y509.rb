class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "c63002b24c7b49ce93346ccdd4b13df66e840612cf724e969a7e7a7a64810894"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47caabb8a492a302fc0648818faef68beb1a3dcc987b804c31fdf0aadd286a02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47caabb8a492a302fc0648818faef68beb1a3dcc987b804c31fdf0aadd286a02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaa0878a242a50b90fdf489f5fe44b5aa703b26c601a76a1cd040a680430c460"
    sha256 cellar: :any,                 x86_64_linux:  "26e134626f42e81b3afab58925c91ca110a6f06af8a9db872f2c0d4489d38c77"
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
