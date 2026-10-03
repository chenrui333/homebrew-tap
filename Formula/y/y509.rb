class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "cd00d99695e38b8595bd2a8c42a264679eb0ae0a7ba478971d4dfa89012c650a"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfded0d4d56ba928225092e9955d62dd4fe6db237fd898a6e98ef883f53db0ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfded0d4d56ba928225092e9955d62dd4fe6db237fd898a6e98ef883f53db0ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96b3ce876096c1d4f43f238e306d22fa017c37d1e3a185bd4e9fb769d5059945"
    sha256 cellar: :any,                 x86_64_linux:  "5b2fb0042bbd3b8f5203d24a57da9f85e6b49bb4ad877675eba9a2f28981c545"
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
