class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "df04d90fda265cba1251f2ee400a854341af6857503cc6edcca532de88127649"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41eb2e9b3e7f0d048ecf85fa8e5902e83cec26a305b97728870ac8f4651b56ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d775820d43626cd258c9201f5c48a3d880b3dc993fae1cb98e5a55b6f4ba2499"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c66312b026740431db78e03d2c750173f1081e8a77a41ddfa22624dd0a1a1dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffb26d8748ca3e6b4696d6a9b1f57c60c994ba6270810a9c445beb57a777e915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11b97bf702aa89806ba01b76f6ea48786542694b35da0c74e5dfc14d4829ecdc"
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
