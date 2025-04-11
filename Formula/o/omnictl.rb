class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "7c0b9035e68b217f6b334fe3ae0e216ae9b3918206af76f715f0dc4ad7158358"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d7f4eee8f285f7c4131026d2807e2b302baa93a37e39263402d4fb2450767e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8a7ede91b88c4c23aa6557c0e125c76a6eb3c6db617e664f7add15d221b3a19"
    sha256 cellar: :any_skip_relocation, ventura:       "c4f0f03969ea96224861a4f136d2edba4646d9d6a20460c595a0ab1df5a9b31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "698552b200c76949ab98a257d9eb8e74f0c552b565d87069e1bd0b2100018fd2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
