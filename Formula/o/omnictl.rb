class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "21114d304517f24759e95e7a4bb3fc8e7b479023bfa128b55d1b362315311933"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de6012423896a1ec833b19c43a935e02cc446e5d7a731aada0a8ec6fd3b1bd3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de6012423896a1ec833b19c43a935e02cc446e5d7a731aada0a8ec6fd3b1bd3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de6012423896a1ec833b19c43a935e02cc446e5d7a731aada0a8ec6fd3b1bd3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79ddcc7586b1801ebaea213dd16d1f512022714b8b10bb1cbe927975d32b8765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69cde5bf290c37a0dcb61e3a34678ec383e3221b909a8bc821a35bed8768ef59"
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
