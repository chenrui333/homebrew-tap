class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "1099b974fe9b6eb64882953aa719ac8f07558654568013d231e4d5a081bcec9e"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06d4458587d54d3d5f84a0b984924eb4c9ed19da2684a15ca319b64c58616aef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06d4458587d54d3d5f84a0b984924eb4c9ed19da2684a15ca319b64c58616aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06d4458587d54d3d5f84a0b984924eb4c9ed19da2684a15ca319b64c58616aef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d561efe34e601918f756a58739792fb43960bda15f84593aa62c9e688d711d1f"
    sha256 cellar: :any,                 x86_64_linux:  "871fb05a0127abb72981c20cd51e44d0456310017bdfdc2e35743d202818d182"
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
