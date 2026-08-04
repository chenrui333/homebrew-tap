class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "d1d356e534fca99a2a752fa486e0256c361132835efebaa4f98c6334d368e73d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "250518928a3fe25eb80dcf9ebec2764940c0fc6a53b06b3d12c7f3cfb5916ae7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2662dd9a454990d2aaab5e931e5b00804ecb2ef6ac4e5daf0f180a26cbf3baf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e239d45494d888ad0a6920d06a51e6149b7d81a23edc6246c991b9aac4410fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a29e8c7fe529cbb8c03512d215712600d9d17b886650239ef65b0b5fc539a6f6"
    sha256 cellar: :any,                 x86_64_linux:  "eaab5c3ac70a6a9167b9d942ecf9bb368321764bd695ca4b7fb2da126eb4f525"
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
