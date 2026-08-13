class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.17.tar.gz"
  sha256 "ad38fff78f6f617add35fa7f7c493ad5dc36310d32ddd2d6b5b69151daee2dae"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc19cd23132eef09f3d890dd40c21fcb8ad21bc2b53d202501c7b28e7dce1c2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61aedcd633cc35844b252af088cdccb377337bbc2c6e5e2f6757e5b6aaa48ca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6dce3a2b462b9fbe92b23c5ee701a76a21c4147ee80a6ed065aaad18a015ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "965eb7349ab221d43025e569fe804c9980bd276f5e1221ef526f86a68bf2f6f1"
    sha256 cellar: :any,                 x86_64_linux:  "a7a92cdfcd0ad3299f708a38075635e2043a3bb00d59c9d4c64e10cc6763ca54"
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
