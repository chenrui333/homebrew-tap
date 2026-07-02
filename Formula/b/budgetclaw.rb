class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "59a7dce63961ad8ffd6d0cb274d790601a7026a6fc0d943e1e99cfe4192c5f93"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5d3bd3fc0e67dbc4f7cbb853ee2a0386c6c7abf141bbbc5a70d89df93d0be62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d1fb6d65f4aad12b7e4b2e19028350008194a4e4a9a0e7d8ed8126522578b10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cd6bb3cc22669a964bd84eb1fdb5f3604a1694674b56c8b7e63cd25e6f69a22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f7fc3da8205c16d650ea155b852b09f0790870700dfb5f659f6587e0af78de7"
    sha256 cellar: :any,                 x86_64_linux:  "a1bcad2fac4ee39a10ffd338a36d7d8f5b2cca18778f27411c57b48d516b63bd"
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
