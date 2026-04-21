class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "84ec79734944676da963ad50340cd03874a00c246320bdc883581a1027845789"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f061327714c61c13800675555b7a1035784e856ed708a52d834fb629769ca67c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f061327714c61c13800675555b7a1035784e856ed708a52d834fb629769ca67c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f061327714c61c13800675555b7a1035784e856ed708a52d834fb629769ca67c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9286dcee90e84be3fa0e72f5f527f0cc949f939be0f734add9cdf3edb48f7d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8876df684557eb62ab15d8170f4d45053cfb8db2d13c756baca4a0423672daec"
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
