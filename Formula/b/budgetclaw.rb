class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.28.tar.gz"
  sha256 "1f462b24ee388b666ac0e804d1ba9dbe1ac05b1c0cfc44bd3029df8881cca514"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ca861f24f17a5e3098c89323bec59cee38a502fa91cc8ac8c5e71e8a5d6f25f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6d2d3a12af7af9a8971edffa15cb761afb7c6ab6604fdf559cc3246f65497f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "022c113d6b0cca3dd8c7ab4f5bc9b97837f8817bbeb968d501c15acb822da860"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3654e0e2f737be3fe27baf9b897bfcbc1e3a2bffe396611ed52b5ebeef69591"
    sha256 cellar: :any,                 x86_64_linux:  "6b44afdccf21d56d5db4f81310fe8e9eaa0dbd66b3126837fb5c594ce2b276ce"
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
