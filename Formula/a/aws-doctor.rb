class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "f54da83a9651313907923ead6d6e2f182087334e13941a2e1421b79efdffb52c"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9771e94dfbebf75d2f013ecd25d6c28e519b34c60d844025bebce16d9eb3ae07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9771e94dfbebf75d2f013ecd25d6c28e519b34c60d844025bebce16d9eb3ae07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9771e94dfbebf75d2f013ecd25d6c28e519b34c60d844025bebce16d9eb3ae07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c4e899d7ca3d319d9a0fefd07eb0dc8419c04ab4102343892e9b7288802f798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3edcb804f73d552c6c6a74ca33fd2b87aa5e897ab48dd08018892aaf8d21641f"
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
