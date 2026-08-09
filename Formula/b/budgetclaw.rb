class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.12.tar.gz"
  sha256 "80803134e85710f61da22d05e7e2c88de977be7d0b2c7104300e65de428a2336"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "953544d02efb9e04167deccbf8082635dcba622e3ebaf4616b10eb8fdc82dc83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36f9546038451257b8ab51cf1f5607f5a468619f44a8d84200663c854f0a10bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5837d5dd02406a91073ae8c531ad5b40a9ec7b5c4e7cb84b8421537467766405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0269fd372f06d1272078111af3c25289e6ab74cdccc984d436b5f63e14540542"
    sha256 cellar: :any,                 x86_64_linux:  "115730de3b66041529ae94a2b307e06db9033f8fb6011670c2548bca73bc04c9"
  end

  depends_on "go" => :build

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
