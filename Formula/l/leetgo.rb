# framework: cobra
class Leetgo < Formula
  desc "Best LeetCode friend for geek"
  homepage "https://github.com/j178/leetgo"
  url "https://github.com/j178/leetgo/archive/refs/tags/v1.4.13.tar.gz"
  sha256 "b92f1708b1420e85c6b97e41f8a09b127a42c387918cba950543e1713195384d"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61fd888f4a37b044755b3f6133290a768840d53333352f33c7b26a72fedce97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ddd598ebabe53ea248f96ec717d57f3d88b392898eb955679c535a323505f58"
    sha256 cellar: :any_skip_relocation, ventura:       "732f73df656c002760bfdf88dd21c8ec2954d85214b2ce742336299e44fa480c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0582299253932afab88de4ca80c8ce687273a791ae19e87a02550e5b6936f374"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/j178/leetgo/constants.Version=#{version}
      -X github.com/j178/leetgo/constants.Commit=#{tap.user}
      -X github.com/j178/leetgo/constants.BuildDate=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leetgo --version")

    system bin/"leetgo", "init"
    assert_match "Leetgo configuration file", (testpath/"leetgo.yaml").read
  end
end
