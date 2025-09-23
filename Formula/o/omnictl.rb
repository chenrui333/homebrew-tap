class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "4f893bc179001919bfcfdd4a940d6c2d67b813dfa49bc4bf4cb08692eac1269f"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a84644605f719a9505f181a00736a5abe9af12c24ac63cdfbc223fd8cb7f253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e72847bff943aeeff0aff8a81eb6a38bedfaa1d407601339f5c2ba36c13490e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "501ec2dd8441fd8f58a8f324c76f30eb3440e2e262d0789c51cec65ec029c84f"
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
