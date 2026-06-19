class Kctx < Formula
  desc "Kubernetes context engine for humans and AI agents"
  homepage "https://github.com/lucasepe/kctx"
  url "https://github.com/lucasepe/kctx/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "34b9892f3d66514322ece2a0f586f146dc8bbe6a7e58665abb7f9717f928de53"
  license "Apache-2.0"
  head "https://github.com/lucasepe/kctx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "159cca2260dceb86bb3e32c02b2cc7d2efb3825b23c66775388c7085718614eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "159cca2260dceb86bb3e32c02b2cc7d2efb3825b23c66775388c7085718614eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "159cca2260dceb86bb3e32c02b2cc7d2efb3825b23c66775388c7085718614eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fdc903209974d5cf2646c0c8820d2835008b3b5ac815b7697c08b2242d93c46"
    sha256 cellar: :any,                 x86_64_linux:  "25a64b37437a8021185d162eda64063458b30e62818f11490bddcd74ab4e0b92"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/kctx 2>&1")
    assert_match version.to_s, output
    assert_match "dump", output
  end
end
