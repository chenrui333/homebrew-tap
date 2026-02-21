class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "841f2470bcd94acefdb22eb47dc2afc223095cba4a3f506d079489dd45ffddc3"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ef9ca839212c2d4364eb62710769faf052ac9aa3192b3251624327539904bcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ef9ca839212c2d4364eb62710769faf052ac9aa3192b3251624327539904bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef9ca839212c2d4364eb62710769faf052ac9aa3192b3251624327539904bcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f713e2e4c4c2a284978c07db24f74458ac463a43dc86e4110ccfd414047d97db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d8e5e3aa9190af8e0802483646126aeb700afb59c5bd37a25c01fadd9031b0e"
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
    assert_match version.to_s, shell_output("#{bin}/aws-doctor --version")
    output = shell_output("#{bin}/aws-doctor --invalid-flag 2>&1", 1)
    assert_match "flag provided but not defined", output
  end
end
