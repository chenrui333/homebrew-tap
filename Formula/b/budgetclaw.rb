class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "eb5013abe365267eee5a14bf9bc93720d8aab8e225dc5769159d88fdc37b8f5f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3bece4bdeb4de29e7b69391de319d13dbd34cffd91cfb9f5ce547165d4f763c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6001098d630cb0ae35ab14945ff5607ce9ea0bfb30eae0b0eb186a28146b93e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cc44bfa8c796d1c495627cb141c79ececcb3deb10a238058cd1bd18b03c4368"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef58c6ca18e53eee93cba55ecf0cac2eae6e135e86f08c573a3e859cf9fbd856"
    sha256 cellar: :any,                 x86_64_linux:  "8823b5b60088edea3979afbfa5e46b536571664c1d20b44112bf91930a768211"
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
