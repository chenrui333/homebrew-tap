class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.117.tar.gz"
  sha256 "fc1018ead7b1dd8b975519ae5b2b021eb04a076d843a4c104404194be748d4c8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fce4ebecb4ed42365ba28098c62eb0ca56e0b3abb31c374f7f735f3cf7c13f0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ead4fc29beb56fb5261c186778004c4f79199ab35145f297f61938b9c2583004"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "232acc654ace7959eb4b78410f5f550f5b4600b86f692797f4baa10ed329cbbc"
    sha256 cellar: :any,                 x86_64_linux:  "8c3116acff058341d9b3a03f882e269a4f3b98efca41bed67f964c97bb00bb86"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
