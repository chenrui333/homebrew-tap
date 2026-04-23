class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "ae17a6629dd4db22b1e7d9b8b7219676db001bb6a551a9029f9a89f472431248"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "488f81027d78ec3429b44eb15a76c99d632b976ee43b1b678c4360def2a8f339"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "488f81027d78ec3429b44eb15a76c99d632b976ee43b1b678c4360def2a8f339"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "488f81027d78ec3429b44eb15a76c99d632b976ee43b1b678c4360def2a8f339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8af1c7f9e312b9109e7046bff1926a6fcb538c42542e7e23052621f6a5ec42dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bbfa9c66a45ab735bd0eb47424740623a60ba190adcdce2adf43cedb80aed0a"
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
