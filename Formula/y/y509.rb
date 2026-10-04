class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "0777fbb7172e73818f67ebcc4669c0a2c9cfdbeac88a357e572d8c07191e3e34"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f783546b1a694392aea8b1afdb4a45da8b8d84a091c7a2848b3d90d08e06b84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f783546b1a694392aea8b1afdb4a45da8b8d84a091c7a2848b3d90d08e06b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdcde95ea215f021f9e9cd72c159f7df5b753ded094a8c6ae953aa5540e75c9d"
    sha256 cellar: :any,                 x86_64_linux:  "a798a69f92ed0c269c52677cca066f3fbdfaeed6f71ead43a6ae6a66ee29e62b"
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
