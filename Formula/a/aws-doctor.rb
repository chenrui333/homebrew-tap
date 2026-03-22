class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "dedc51c7d71feaff6bf86a4f9521127518506bbb687c396925ae8bd536bdb995"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9555b22a00315ab4ff1081991695d68f5631815bee2d978b0b1223d4e2ea70c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9555b22a00315ab4ff1081991695d68f5631815bee2d978b0b1223d4e2ea70c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9555b22a00315ab4ff1081991695d68f5631815bee2d978b0b1223d4e2ea70c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adc61466a9f07e26d6b75172cf5d32afa443634d8256c709186ef363cd542c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9f847fdf9ba5c10273ae216c3beb4779d6a54ae1904dd68f713880361a2763f"
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
