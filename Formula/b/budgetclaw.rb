class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "4b14b0d919f1d61162817516d6af45f3b5137d7e2f48c56a64764da9d9d85bb6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6ca4bd52a36777a55be2fc1bf9b6a08817f50cc517b64549ca5e5d6478ec930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e00a0d68b70e1df6c0410347d9fdf38e2befa5c615196913fec49effd081a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfd38c6585269b820b84b732c244196ee103364d70844999d2a0ab551528aeeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3875c823937a16baa090a65d9292c891d44e840239bea46c6d031c182b46ceb5"
    sha256 cellar: :any,                 x86_64_linux:  "5001eeba8b64f9292874bee8d4792bf858af6aaa9acd5b2c8a3c7887dcf0cd74"
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
