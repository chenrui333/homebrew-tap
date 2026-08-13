class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.17.tar.gz"
  sha256 "ad38fff78f6f617add35fa7f7c493ad5dc36310d32ddd2d6b5b69151daee2dae"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8b5bfcec84afdb91d55ab133fb12548d2a5c8d2fd35df0e75572e2d509a41d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb81d2630aa4f3fef7df207c03c9a70131c7a584b17917bc6034413df133dc1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eff58d44e3c57d4238de593f46aecb104fcb5bac4d2086ce9099f4a8b295577c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5408d6dc0f3c0cae58fe5dbbdac63496f8897f5f7bf005b02a5259d858eee7d"
    sha256 cellar: :any,                 x86_64_linux:  "9f690f80129f9ded2d11ef938774598dad850a8258cefa5326f3ce5a6e0e86a0"
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
