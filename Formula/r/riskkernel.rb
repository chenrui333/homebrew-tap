class Riskkernel < Formula
  desc "Deterministic cost, loop, and time budgets for AI agents with observability"
  homepage "https://github.com/prashar32/riskkernel"
  url "https://github.com/prashar32/riskkernel/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8ac625f8e6c95d012627cac3c041021a234e75ae4ec755dce4962222e7d28d19"
  license "Apache-2.0"
  head "https://github.com/prashar32/riskkernel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f98acd5ae0f0dd196d99ffb40153bdb93c6934b1ca77f4ba2ad0c519e4ba770"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f98acd5ae0f0dd196d99ffb40153bdb93c6934b1ca77f4ba2ad0c519e4ba770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f98acd5ae0f0dd196d99ffb40153bdb93c6934b1ca77f4ba2ad0c519e4ba770"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2385492de11197a561afaebe416fe50f9502ac21be939284fc012a2a11cbe06b"
    sha256 cellar: :any,                 x86_64_linux:  "161fdf39a0a5957f4ee93545870435f25d42521d7bf401420c0086f6bc2b8a43"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/prashar32/riskkernel/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/riskkernel"
  end

  service do
    run [opt_bin/"riskkernel", "serve"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/riskkernel version")

    output = shell_output("#{bin}/riskkernel policy validate /dev/null 2>&1", 1)
    assert_match "policy", output
  end
end
