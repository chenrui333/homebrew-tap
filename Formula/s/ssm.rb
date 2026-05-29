class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.5.1.tar.gz"
  sha256 "8c0744ddbcd2a80c44564749af8c5e6bd181fa892e8c3e24a6e083730836a029"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5481482f05aeea2891732a3959d93b12298562de8ffc3b058c43f248689f3de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32f2dc2f9f432f54f9d9998d74fd233a851a50dfcf692e645934ab36f70012c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad9aedee25b1971a4cb76f1dbc620e7dad8f0172092c4abe6f466b6e9524a036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5361d9226457445a7f6c21eca705ea219c9fefbff51fd4f64bdfc6bc9043ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f41ebdcacaea2b1af05d1892da590b8dbd74918350fdfda191013c641932db3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.BuildVersion=#{version} -X main.BuildDate=#{time.iso8601} -X main.BuildSHA=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssm --version")
  end
end
