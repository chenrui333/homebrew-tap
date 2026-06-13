class Riskkernel < Formula
  desc "Deterministic cost, loop, and time budgets for AI agents with observability"
  homepage "https://github.com/prashar32/riskkernel"
  url "https://github.com/prashar32/riskkernel/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "16feb81d0f05129113f71d17731525093948a9bbc03d7ebfb92bc0deb447130e"
  license "Apache-2.0"
  head "https://github.com/prashar32/riskkernel.git", branch: "main"

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
