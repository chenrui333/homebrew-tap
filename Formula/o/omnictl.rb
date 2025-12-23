class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "ebdcf61ebcc63b30aca761527909e5cc5568689476b6350f3d26883c58e54ba6"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e419c383d6b4dbee424bb64dd39861bb6fa29d88b460ae2d2f50263c3f5638d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e419c383d6b4dbee424bb64dd39861bb6fa29d88b460ae2d2f50263c3f5638d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e419c383d6b4dbee424bb64dd39861bb6fa29d88b460ae2d2f50263c3f5638d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2123719b643c2b1f14d6ac23dc71f5bfd729c8f78d391b8c2f5eabe6947cf433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b6a24706826f6c3a16a464e2425be182fe6e57ab397196c9330d51c011260e4"
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
