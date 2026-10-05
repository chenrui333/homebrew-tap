class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.80.tar.gz"
  sha256 "7fa5954471c18a7cc8a2da32fe6077fff9b09de6f968ef6efa82b9c22cd568ff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad3e80aaba471cce1e706c1c63533a75335e7afa094f0e63632fd30195f46d58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28a741cb3d41c2d453d49dd761c027ce5ebfda89cfe126c09f92a6c31b300329"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "955c8f67166df23e1869f1bafb0e157ab268a186dd4b2719e3798d3f71815fb9"
    sha256 cellar: :any,                 x86_64_linux:  "72b527f7901dcad7c03895ac1e6c9ec17195ae7ebce7149bbdd535b68e467886"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end
