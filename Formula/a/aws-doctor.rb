class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "f54da83a9651313907923ead6d6e2f182087334e13941a2e1421b79efdffb52c"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99c2651deaa23d7873d3caf452a8379fbb0645732c89230197cba642e138d5e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99c2651deaa23d7873d3caf452a8379fbb0645732c89230197cba642e138d5e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99c2651deaa23d7873d3caf452a8379fbb0645732c89230197cba642e138d5e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a1929977e37f07bc0ed0b8b09bb09c508c38cfb9a3df3078387c0b0880e4fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "888cd735717360343220326ab910f00c088bc1e6dba85e539c8ab76fc1221aef"
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
