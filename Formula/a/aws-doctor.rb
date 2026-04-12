class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "7f0edf7ec10d37d07eb93bf064d34fdf2dbdeaa46ecb850617fba27299bcb4b2"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8506519d1d0c2985a9be5c0842a4e4d01ccbbf5d6c727ace511517340b7add47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8506519d1d0c2985a9be5c0842a4e4d01ccbbf5d6c727ace511517340b7add47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8506519d1d0c2985a9be5c0842a4e4d01ccbbf5d6c727ace511517340b7add47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a65e302c85a39e6ea5a375bd972aecb75fe95d094dc9730883e571096c321caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "953e3e00d18aff6931469340de60a5ab9a6f34ebaa60caba3cbadd81cb08a8ca"
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
