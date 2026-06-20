class Riskkernel < Formula
  desc "Deterministic cost, loop, and time budgets for AI agents with observability"
  homepage "https://github.com/prashar32/riskkernel"
  url "https://github.com/prashar32/riskkernel/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "af894afc5c70b1a0849b581b96ca54beb8bc0e7ab5517a788f38ab90006f9960"
  license "Apache-2.0"
  head "https://github.com/prashar32/riskkernel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "496389ff26a14196a194c66cf7f6e2503cb9caf6a25249b14cfa0efc8e6cc3d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "496389ff26a14196a194c66cf7f6e2503cb9caf6a25249b14cfa0efc8e6cc3d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "496389ff26a14196a194c66cf7f6e2503cb9caf6a25249b14cfa0efc8e6cc3d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49aec28ffb96a349f7e51d37faf1b116de90340d8b12a02366d4f6581256d1d0"
    sha256 cellar: :any,                 x86_64_linux:  "d0db6ad73ed6e65a479c8c5d3ac816af62f1ecc4f52cae65c78a19482e707656"
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
