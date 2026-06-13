class Riskkernel < Formula
  desc "Deterministic cost, loop, and time budgets for AI agents with observability"
  homepage "https://github.com/prashar32/riskkernel"
  url "https://github.com/prashar32/riskkernel/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "16feb81d0f05129113f71d17731525093948a9bbc03d7ebfb92bc0deb447130e"
  license "Apache-2.0"
  head "https://github.com/prashar32/riskkernel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4089f02b5c2b4d80a67f958de118b79855c8232d83d0fe124711ce25865b1093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4089f02b5c2b4d80a67f958de118b79855c8232d83d0fe124711ce25865b1093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4089f02b5c2b4d80a67f958de118b79855c8232d83d0fe124711ce25865b1093"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04d7c41ec299bc5b4d1535a54d48d004739681031de16a3373dd3e142b89e279"
    sha256 cellar: :any,                 x86_64_linux:  "48a3777bbdb568f873d7379b47913fe84754292d5b5da1927a13feb91a696450"
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
