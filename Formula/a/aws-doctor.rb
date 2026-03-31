class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "a0c11ae71599b1ab89aa72045fa9cc10dcf70953c789ec11d383423843d3ecee"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e99b4e928ecc0f2bfc40b5162f73b3f98d3487ded0215b5afcb717ee852384b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e99b4e928ecc0f2bfc40b5162f73b3f98d3487ded0215b5afcb717ee852384b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e99b4e928ecc0f2bfc40b5162f73b3f98d3487ded0215b5afcb717ee852384b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4744edd8984f16423ea0eea1a0970bbac9ead4b6448318392ccb4b09e472c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e538ec8227aaff6bd17bf528c64a9f90dfe5d084cc0f7f309a90f268595f280"
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
