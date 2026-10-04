class FlowNetwork < Formula
  desc "Real-time network throughput dashboard"
  homepage "https://github.com/programmersd21/flow"
  url "https://github.com/programmersd21/flow/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "8f6f25a282b89360ab07438dfde8de7ec843bd8c819369f531d45897cf4c1195"
  license "MIT"
  head "https://github.com/programmersd21/flow.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2da76078c6707bdac97851b6961517cb0d8a63805365964dc3c999f1208df8b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "794751e0a50d9770bd344ae7ec0872851c1766dcf18d7817381fb8335eb6ccfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "698f1d478e3b2a5d8bd38994e0620aca17d2a80f37b21a898bc27ffe86ccc838"
    sha256 cellar: :any,                 x86_64_linux:  "a2f9c9874d70bf0775d35f6ce56f2f1a2ed40bd0fe521b85f89d0b1be2576390"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/flow"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow-network --version")
    output = JSON.parse(shell_output("#{bin}/flow-network --json --refresh 10ms"))
    assert_equal "ok", output.fetch("status")
    assert_operator output.fetch("download_bps"), :>=, 0
  end
end
