class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "ddedb5edfec66a8c96cd0d652131b40518254aa9d2b8698541d677b555cc8f55"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3705e6f609997cbfd94fdd68e725745b3363b1e05dc5c5c5f9d396da2af4af3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3705e6f609997cbfd94fdd68e725745b3363b1e05dc5c5c5f9d396da2af4af3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3705e6f609997cbfd94fdd68e725745b3363b1e05dc5c5c5f9d396da2af4af3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37222ee4f6f8617af6aeb9ab9aa2417c592552a2d64d01df7ca00a5cb6e84191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14a11846582c4441a828585b6596f9446fe6074909e6077986250a045f12105"
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
