class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.5.1.tar.gz"
  sha256 "8c0744ddbcd2a80c44564749af8c5e6bd181fa892e8c3e24a6e083730836a029"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07171f52a2729c2c4434aa511465906336bb1931f278343edf90ec6506b9812f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83645d46f22de987b90c271495ab715f897e7811a619ff57dd3059ab0f4bfd61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2d764c187c7d91fcd13fd048c622d178686fa5252d1e7d285267ed902065015"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bf223d2f4b695bf5f75bcb388ffac9be74ca87c071c9310d6c5d23859ac54c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "789f81ed5214c88517b2264154fb8a08fbc57e4a60d739e0161190471532af3c"
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
