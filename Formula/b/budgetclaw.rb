class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.79.tar.gz"
  sha256 "b5ce7553a89262d979effc7db9d03b69c2e7f17bcace68bca7551824a47fde5d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33cfebb93d2ec9e83d897fd078404c7c632c06c2914877aa2358a0c6c9218960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6fce5e09e6e72f896c5bcccde3644c10937a26182ac423a864db4b127ed08a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2555770f8fe544cb1713269e090db96fbdaea8d27a6a60f8e752a9e301591aa8"
    sha256 cellar: :any,                 x86_64_linux:  "440f36fc9509e30b015bdd575405802ea74edd7e83c7b8522fc6b854ed54bec4"
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
