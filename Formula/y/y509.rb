class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "a881e5ed6694426e0d36d8be6844c037084f270c2bc7482da1b315a9eddb7a0b"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad66f1888be74063a97e79ba450b651713e1dbf647cfdb72268ac807ecd79c5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad66f1888be74063a97e79ba450b651713e1dbf647cfdb72268ac807ecd79c5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "656780c5087b4747265f9855ae2edb07d60bbc430a7e87469035861c0ec206a4"
    sha256 cellar: :any,                 x86_64_linux:  "fbcfcab907ba41f45ddd30ef61453a2b113291ee1204eff4b8b8bc82ff74e4de"
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
