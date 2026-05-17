class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.0.0.tar.gz"
  sha256 "3e335523da7d9982cca82f5638afda50d25332e31af08bbe5320494b572e72a2"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3a494e157e949122c3826d029d13819702922483ade9a5be49307b6e5c31af5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3a494e157e949122c3826d029d13819702922483ade9a5be49307b6e5c31af5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3a494e157e949122c3826d029d13819702922483ade9a5be49307b6e5c31af5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e75d686a514c9881b5d843247065fd4b164f0eae61ac7138dfcebbeb582c7334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c255ffe8bf7e47b5bcfa1952f15754d4aca52af416b72ded9b59c1560e6a7f"
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
