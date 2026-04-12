class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "7f0edf7ec10d37d07eb93bf064d34fdf2dbdeaa46ecb850617fba27299bcb4b2"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a96a2b448050ae945b712c305f1896e7f32678fc5551792cbc0fbcb62c71373b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a96a2b448050ae945b712c305f1896e7f32678fc5551792cbc0fbcb62c71373b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a96a2b448050ae945b712c305f1896e7f32678fc5551792cbc0fbcb62c71373b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbd983547af2bc3d226404c5d2ad0336b36630057a26830b45970937d844863c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca108ce32c817e6191f94680b028074fe23c07b55b8a9b916011a83db8258daa"
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
