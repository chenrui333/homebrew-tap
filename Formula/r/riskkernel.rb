class Riskkernel < Formula
  desc "Deterministic cost, loop, and time budgets for AI agents with observability"
  homepage "https://github.com/prashar32/riskkernel"
  url "https://github.com/prashar32/riskkernel/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "807bd925810d7afe864ef94251ac3baba938069a3e6aa4918484dd324da97c1e"
  license "Apache-2.0"
  head "https://github.com/prashar32/riskkernel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1a49b141fc3571cf57ec01b267f5eba9b151134b13a44fa456bfe00955de55e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1a49b141fc3571cf57ec01b267f5eba9b151134b13a44fa456bfe00955de55e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1a49b141fc3571cf57ec01b267f5eba9b151134b13a44fa456bfe00955de55e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c074ec864c56617f2cf89283e79ee60f9f787b554789187ed40224445a0164a1"
    sha256 cellar: :any,                 x86_64_linux:  "6fea4d391cde95bab39c5d28f19769efc1fdc2ba0f0484b6b909c482f33e72a1"
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
