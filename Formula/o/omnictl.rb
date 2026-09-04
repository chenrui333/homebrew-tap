class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "14f9e5dc2a25a65fcf3a12e423e9513015397a5b9f0836fd8a7fe0cdb2edd4c5"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fa921e848777ede4d442de1af71a88b737d85ac368e100df5aa97b5e4e38e26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ba963480222a00c6f10bba133c59f83c8aa06d22e5f77dc436c79b023db420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24022ed4c437ff8ee6ef3be94d8363131a5e53224c569053cecf5471913e0e21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fae7274d6cca6f6301436f7690a34fdc27f421456dc4cdb4de99bbf1aab7d575"
    sha256 cellar: :any,                 x86_64_linux:  "64ca892bb4dc5fbdf55a472517f67ca17643238a349fec46961b839a8da3280e"
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
