class FlowNetwork < Formula
  desc "Real-time network throughput dashboard"
  homepage "https://github.com/programmersd21/flow"
  url "https://github.com/programmersd21/flow/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b6bcd7afdaa290253e33d9196fdb2349dc044c6bfe3b6e6500d0a3df7c0b13e4"
  license "MIT"
  head "https://github.com/programmersd21/flow.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef6578a9c9b67c89d39fd25835060b7ea249c8706ab3c0b097830e50d5dd3565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cbeacc07b9d2ba51af223990d36e5717a99f0e9f654f4bbbbce39d1241bc106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97f327e4f2c0fbc33024d38cd0b0c34181e6a713c162a3a3e890a994e9edc43f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29d05a1482151de68fde3468eca1d03e44cc8087408e48e3881ecca47820d822"
    sha256 cellar: :any,                 x86_64_linux:  "a1990ff8d95244e078a1e6140be1f7cfd9362c3c713053959784be5454442ad2"
  end

  depends_on "go" => :build

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
