class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.39.tar.gz"
  sha256 "2bbfae932022994b7cca2495ecad35bcc65717295c7044cdc73a6ecde18b66ce"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3314f925e200cca3db404ddf137c6f0f8ed396ef81c258ca368d592c676da0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8d4b710facad9f7ca01e72682810c272cf554c76315ff743f4fa5241677d73f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e17d9244d1604a5f9c3305bfaee828bc9597c9824f713a55d7596e148d6fcf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63d20b8169c905144a869a3c5e5cd7d76cccdc0c4b711978963f4a04baec5b8f"
    sha256 cellar: :any,                 x86_64_linux:  "5d0d62929c724c087582dc3663790a151648a47cccdf3546850bc68874bf22aa"
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
