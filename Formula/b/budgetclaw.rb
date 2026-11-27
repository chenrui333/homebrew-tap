class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.132.tar.gz"
  sha256 "8acc25028375941cf53dc1daabc2ac427cc797cff05c639aaf759c1909598c59"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "bf62a858480b7c5d4f0b0d5a4aff1315da99c6a92af8638207ca19ea8c48b8a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67c969025a7aabbd827fc69e779ee25c42f9a37d87c79b04513755c9506286fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c40bacce67bc8275e4d42bc4e57be4af6c766e3c01fdf42c3e2d5c96e4cac618"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bba221253d07dfc2c7cee09a111fe460826a0ee52bf9f98f52c34def40c97486"
    sha256 cellar: :any,                 x86_64_linux:  "eb271a35efec0f476bb05d9e02a9e94aad657c16cbe0612a7b0c8a5e1a4c6523"
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
