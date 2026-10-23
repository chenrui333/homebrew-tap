class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.91.tar.gz"
  sha256 "9daef6a37d07a13fa4d5cc61d689a89e0b9120d7aca8219dd7f808c35bacc972"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f0a4a69ca2f19df6d7c89f3fce068fc5a56f9f82d4cd29da0dab33cb23df2f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d8f039a1f931867141bb02d2224c6c932d6382b38b179c1376f44a52e2f5d54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b93b506601bd344f847e561de92a9f14d6da5d2cc5a0d2511db4ac1df93960"
    sha256 cellar: :any,                 x86_64_linux:  "3f00b5a7cf32163e4e27ee3fa201adf32257ca8223c65503d6dc0bf043afe7cd"
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
