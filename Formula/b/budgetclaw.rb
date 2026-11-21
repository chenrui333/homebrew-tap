class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.125.tar.gz"
  sha256 "540a456826afe3c7ee371a7df4500081c39d0cc9debb64fba83b86cb80ae0fe9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "c98a777807990ec226a00f2f1697888ce18e2a6984dd4a9524191b84ee875467"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e77ca9c7353906c452f9d443812cd766662d12c88ab09c50518304eb1104130"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b454b27740b88e906b0315e53ceb64cdbb9470155ab62a2ebb2b18d1f312a533"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b79701b1d2b619083455dfdfc7d73d566ab4af42215bc6d15f9a21e1f930e348"
    sha256 cellar: :any,                 x86_64_linux:  "4c2fe58eb03ecf68b1c21a81f2d2653fa651773d30f9d4ab763e07f199b90976"
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
