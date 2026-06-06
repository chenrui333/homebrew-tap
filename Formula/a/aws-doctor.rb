class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.21.1.tar.gz"
  sha256 "2d2707e50ee3360389eb279cb3e3a166912a6439cb974324df758c8a5416f43d"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d85fd16ec0de284ba0bd27b2c86b5ab66b73c4158a70308077973acfb7a2de6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d85fd16ec0de284ba0bd27b2c86b5ab66b73c4158a70308077973acfb7a2de6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d85fd16ec0de284ba0bd27b2c86b5ab66b73c4158a70308077973acfb7a2de6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5219533dd66118dd7f40aa81aeb048bf3877646beb8a9fe179e30159d273816b"
    sha256 cellar: :any,                 x86_64_linux:  "65017c5218cf3d66dee0e199f18f2ea49d76fefe53a421221c18fd536fdbce9e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-doctor version")
    output = shell_output("#{bin}/aws-doctor --invalid-flag 2>&1", 1)
    assert_match "unknown flag", output
  end
end
