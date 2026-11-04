class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.103.tar.gz"
  sha256 "2f6f6fbffe17115f2ad9435e4882793385a550213008d78c899552abfdc169b7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3072b53746dad37c54c63c19897e5be2f019927f78f360e98709fd721e5e7534"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e61f72c62672d5965cde87b567a48ca51b4ca01072fd474cae8de37b9ecacde8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba2222d81bc8cd54e044980eba2346811c91be5a7258e10c861a7153aebf3c80"
    sha256 cellar: :any,                 x86_64_linux:  "57e875a792077ca7ff5cc2b5f7249c5dd248be45db006e848fe884bf0bb36984"
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
