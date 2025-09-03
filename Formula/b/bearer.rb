class Bearer < Formula
  desc "SAST tool to find, filter, and prioritize code security & privacy risks"
  homepage "https://docs.bearer.com/"
  url "https://github.com/Bearer/bearer/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "ba8d621ef954c2a5f43337c9f401d05d74301b101272101ed386182c3834a774"
  license "Elastic-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "372ccef6c52ea14afca4879954f55fd2a4f63a8d7c2c640f62067c1df47be769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4d45a21d74634e63ef0c69aae93d069a0ed6e1519d463b64da75665cfccc6d1"
    sha256 cellar: :any_skip_relocation, ventura:       "eb558fffc0623bf359e0e40643b30010364dc06dba7d54a5173e27d5f3a7ff34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9035b8e4689b2bc8cb0c893441c649df1161f1d9d67df6e2bf799c533d2dabd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bearer/bearer/cmd/bearer/build.Version=#{version}
      -X github.com/bearer/bearer/cmd/bearer/build.CommitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bearer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bearer version 2>&1")

    (testpath/"test.js").write <<~JS
      const password = "this is my password";
      console.log(password);
    JS
    output = shell_output("#{bin}/bearer scan #{testpath}/test.js 2>&1", 1)
    assert_match "CRITICAL: Usage of hard-coded secret [CWE-798]", output
  end
end
