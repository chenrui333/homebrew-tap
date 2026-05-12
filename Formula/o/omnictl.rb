class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "c6017798399436c72b6313f83cc3b1e23cd4b9cbd4a29c30fc3645a2105e8133"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "222e033040a85690dc26b6f5a1c0f6c276ad0b046065de36fc711218f5a78c0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5152c1c1707093d9891f16469a5cf9c7b0f7f7d0d5894707e6efaede6d8390c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0edc384a52b4a6fb1a4d9b743fedc4c72885801794e4138ef702582791200c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "529f17030951af6499a272552acce38c6e262b9c171bb10b026cb66d0a00d990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0a04fda5e91257c38ae559ab2a5f877cf741bfcf254e6ef013b0a405d6154f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
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
