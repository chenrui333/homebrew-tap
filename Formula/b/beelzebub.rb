class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "df04d90fda265cba1251f2ee400a854341af6857503cc6edcca532de88127649"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "904c3f95d43f83fe40951288233d35170838d4cb7eef47d269a690a0f6a08553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e4e191e45e17c11f77d59b7600b15001336036d5f34fa6abf332c8531b45c27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91cfdcabb5e49403c4e9387781094639d0b833c72dfeae440a6b9fd15b881b21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc9dfe58dcbce7bfef69c8d85aa02e0df7bd5f63b77cd63517ff60c26ba4451b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8bce781c2ebcef97b29ef353a3d88c025d7ea72142466b9d1b5a07a58446159"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/beelzebub 2>&1", 1)
    assert_match "Error during ReadConfigurationsCore", output
  end
end
