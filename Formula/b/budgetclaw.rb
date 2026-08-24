class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.31.tar.gz"
  sha256 "db5a88c94f706d235bbc1cd16ca1577a464a5c2f82417dc99bcb3ac7c249090a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a323ed56771e12d65f289cacb66e86e9d92f273981ca275ae848dbe9eeeb3ab3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a51654b718215195500e55c5e72babae84bad2b6f005bf9c8af71d420bc1750c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89d0b62bbf6e2ea33667b9f2f37bbf7aa3705f5b7f19bfe2b4b3c8a0a9317724"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f2fc3573c7eb059c810b308e145af0755f7186cdfff9209de13560601525f0d"
    sha256 cellar: :any,                 x86_64_linux:  "7d55198e4c6f5b451cc1a99192b27d5d8224802790856e1820d2e84806b223e8"
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
