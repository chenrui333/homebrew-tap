class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "a284603f269540c7a6cdf4b5262d203d43b0cc398350076f0f4445ebe29d9a70"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3782144b12b4cfeabff5a242ec34290c4a828d2a534105dbf293f2b58924e9a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd159535f43572768d589373b0ea9ac5a54f6c659474ce60a1132955f37fd4df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "565877e959c5e824be4f9a071a61a742dd2afffc3fb71b842239cff4c5a23240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a4797c4ef3ca8cf91841669bcef0aa30a213bbb8af9f6fc56f99ca4c1c5b4af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67ccb1212ecaa8fc0069e2777a1653950dc023b69eee60cd141fa13e6f14d18"
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
