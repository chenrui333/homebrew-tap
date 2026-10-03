class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.78.tar.gz"
  sha256 "a3128c274913fa5534674cc01650d4e61c26e829498ec2ec38b085315a48edfb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92073173f1442134a25fa8c7b57207512367e05447a41d1ebba340717d31f914"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e8b8c152ba70ff413ad230321f9282ac0add4a55121cab914fa3ce3ef35aae6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1f36fc3baf12ac06e3eb70deea3a9e34d8d67222b55ebcf5cb4e99826951494"
    sha256 cellar: :any,                 x86_64_linux:  "27941c80e367b24acdca7b81d517989372cc3c455e76a69b763d6f15bab13750"
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
