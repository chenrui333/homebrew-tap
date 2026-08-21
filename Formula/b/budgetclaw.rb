class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.27.tar.gz"
  sha256 "8ce67ae9ea1d4fc7aab73f6877a63f5d753cc4b3952e7ef2f0af1b8da9ab0035"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "263480abb3b5ccc35c99656da4bab19c3c66f2cd3c5522921ae5ca892b246858"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "843dd976b5d312187679e3e55322c157574bc31ac0494d7447f35eef447d2fba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea2ac65cc1eb665cc9bcd8ba39f90897e6a87e7f13adbba2e625f4bc4075a301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91f348261d020e15fde83bc7ac7606ed3a0241b1e3043aab572bac348ceee197"
    sha256 cellar: :any,                 x86_64_linux:  "ac87ddd9e1e432566c171f211e0565f93b3f8e38e143f4ea83d4e185a7c5cff3"
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
