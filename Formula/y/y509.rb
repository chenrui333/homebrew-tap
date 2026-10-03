class Y509 < Formula
  desc "Inspect and validate X.509 certificate chains"
  homepage "https://github.com/kanywst/y509"
  url "https://github.com/kanywst/y509/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "cd00d99695e38b8595bd2a8c42a264679eb0ae0a7ba478971d4dfa89012c650a"
  license "Apache-2.0"
  head "https://github.com/kanywst/y509.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "532598ba8eec707526736b0be8dcdf069e7477c642659c038540b0ff3e0ed9c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "532598ba8eec707526736b0be8dcdf069e7477c642659c038540b0ff3e0ed9c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043497bae402d20b2784029e3139fa1a11777b427e4424c5d4cfc1846522db47"
    sha256 cellar: :any,                 x86_64_linux:  "7225af9b585f7977a4c285c6cfead5af43b43c5da46cf032711a943dadc7002c"
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
