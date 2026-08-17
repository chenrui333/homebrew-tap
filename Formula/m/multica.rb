class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.4.28.tar.gz"
  sha256 "b23bb8d16d4f74430f653905b8553bdd171cdf1f8b235c77a2ebbd60b68b0a32"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "315c00a873c9dcdb9801d5356a4bd926bcd9fc6783d5e2a00ed4ebc4fe9e9eb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "315c00a873c9dcdb9801d5356a4bd926bcd9fc6783d5e2a00ed4ebc4fe9e9eb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "315c00a873c9dcdb9801d5356a4bd926bcd9fc6783d5e2a00ed4ebc4fe9e9eb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec231088979bd231cd5ca7c79f15efe3a4b32ec2e9daef94137ad0a2fe750983"
    sha256 cellar: :any,                 x86_64_linux:  "28e85ce842a2cbc67625efd6e4b8579e0ec6ca90e793691a97a158cd45bc8ef9"
  end

  depends_on "go" => :build

  def install
    cd "server" do
      ldflags = %W[
        -s -w
        -X main.version=#{version}
        -X main.commit=#{tap.user}
        -X main.date=#{time.iso8601}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cmd/multica"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multica version")

    system bin/"multica", "config", "set", "server_url", "https://example.com"
    assert_match(%r{^server_url:\s+https://example\.com$}, shell_output("#{bin}/multica config show"))
  end
end
