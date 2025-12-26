class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "9508b9d81038bc3618257da23312808ea040ef0a57d7d78dc1c3e23732bde4f0"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9c1070dd6a2eca3d71cb364ca26122e95bfff828c10edda206c480a31c7aeec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9c1070dd6a2eca3d71cb364ca26122e95bfff828c10edda206c480a31c7aeec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9c1070dd6a2eca3d71cb364ca26122e95bfff828c10edda206c480a31c7aeec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bae8e806107ceb4304516784ba68d1c7f788fefdf28dcc992b9f5728a2e18ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2809dc1af33c3af92c1441ea514844fccdea3359201a1174fd2fe3f5100c0965"
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
