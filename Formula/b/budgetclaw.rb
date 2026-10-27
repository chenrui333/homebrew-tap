class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.95.tar.gz"
  sha256 "6b9fe2701c7ee8cce2cd146df15f942f35ae2c888ced83141ed620a6c74d76eb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "087ee633dd1465960ab95d2e9e12a791b9ba44655bccc78c1c51371464a84762"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9531c24407276eecf5e1b327ff3cf1d332f0178541771c4b2a7d4cee317a4efb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "274d30cb783e87e17d40c26d7b61eb80eb9d9ada972aa8c822ef00c2ff536631"
    sha256 cellar: :any,                 x86_64_linux:  "c6e1d20adb5b1e9e1a7a51b3662817525eadafa3a066499fc6a9124cddd04d73"
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
