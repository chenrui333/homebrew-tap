class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.40.tar.gz"
  sha256 "9fa61674433c10637c214f844266e33913d825cbd628a79c66f4add1d2734e9b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7210008e138ed41f13d8782bf80421b2d1b5b9b98fa2028913691322bfc5e495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9287559af2ebdd5011cd0bcee6874dab585209005064c15a6d70b32805107980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78c6e2f67472ef78b7272f8b0e5e1b5c4eab5d2f7dca12bbed9dd7c81b46f0fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d2662fda9fdeaf5382e8808fe7e1d7d04dbccf33a58296ea5f7259b5411253d"
    sha256 cellar: :any,                 x86_64_linux:  "b651b514c1abbfbd5888c18b0748bf81a7e82cd4c23f8d42fe6fe152aa4a44b5"
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
