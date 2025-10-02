class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "51df88167f04e043b077e0df0a10d02916fb6b2022ed89af80fca3502139ce73"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe39ed6d2dc70d1529e263779191446a08b7256d4a96c4b36aad04e7822df753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51e76c87edcee1def2f30eab738963b3289de96b3ad86cb837f25e0c192fde72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0192bbc15d72a31874f0352a65d75b7dcebbaca381b2d3c1d93443a1cdf06277"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", "completion")
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/omnictl --version")
    system bin/"omnictl", "--version"

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
