class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "7fcd3146fe5ce6ff10a83afb8825400ed24d69e814992609b893fb5a7fffa184"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ebfee50c6997d9d8012271feb5b04c2b85ede256a5e225650c1a0090a13c581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86451b83db1b19719939d24dd978339ca194696923fb034739770c89eab11bd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7660faeb9aadbb2a3d3ba00c7530048c4c9fb6e1b6f74eed4fee29942b5a5c21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a34ab81677998968899dee1e731f0fff00d675daed8d2f43d67a331efe64b9f"
    sha256 cellar: :any,                 x86_64_linux:  "7528d17b92c8ecae19c4301220a987384c9079ceaf67ed1df4d8ccf121a2a414"
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
