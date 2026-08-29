class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.36.tar.gz"
  sha256 "9f3a3104a54c80f9168c9944bf58a7ce24f3385cc91f455702f69fbbeae217e3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1c6e81e80d7ba071fea37ef74c92527f8a0d5c58bcecacd309e829ef684a8ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea3f5b62b6e36b81104fe0f61393cb65cc99e4e8f97a12b028a673b159960e2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "461e36419b78ea8fa8c56e8fad69c4197dc4c3daed2a29a6fd3477b6cec176b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f5a86512a1b770ff4869309e43c33201ec725e2cd08e7660bbc8dc5ee9a6393"
    sha256 cellar: :any,                 x86_64_linux:  "6f617a3458eb1fad70b1682de1feb5bf5af52bd5803dbd2273973232c349ffab"
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
