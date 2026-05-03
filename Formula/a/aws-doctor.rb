class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "90fb45c9008bf4eb2374b7f3213cdb9965d6e50fc6590f88547b89986cca7a2d"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "416c0b0447f1b18c58fcf97c3977932cde67e0785934208f5030f701af319d4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "416c0b0447f1b18c58fcf97c3977932cde67e0785934208f5030f701af319d4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "416c0b0447f1b18c58fcf97c3977932cde67e0785934208f5030f701af319d4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9858052cec4bc86fdb7be462d669adf7d3a7eb320081596867d9f6905d69715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d896d5d28d63a13241c986b73cc88186d634afa1604bc07c1f4a69673d17052"
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
