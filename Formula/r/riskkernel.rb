class Riskkernel < Formula
  desc "Deterministic cost, loop, and time budgets for AI agents with observability"
  homepage "https://github.com/prashar32/riskkernel"
  url "https://github.com/prashar32/riskkernel/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "af894afc5c70b1a0849b581b96ca54beb8bc0e7ab5517a788f38ab90006f9960"
  license "Apache-2.0"
  head "https://github.com/prashar32/riskkernel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3efc23b8f84e6cdcda388e6cd8005aa5d4ce7180df96e17bd0086f4a34ecc68d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3efc23b8f84e6cdcda388e6cd8005aa5d4ce7180df96e17bd0086f4a34ecc68d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5a862d819059e2796353d8e45e0e30720e5edce4ba5b301ef7a8ad95ef7ab15"
    sha256 cellar: :any,                 x86_64_linux:  "bb2fbac2ab4823ea2b184c34c9c7a3aa12492f422da66636f636d0454b5063c9"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
