class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "951be1cc42b7279056969794e820580976f9fbde8c14a2f118e19bb49fad6ea2"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f0901b22c940d4f83512b08c8b4e5cd4e4ae6a197f31ea41797986adf803bb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34b92d5785e94462cea5b6be24a6081c65362502827e96c9ca1157490cbf63cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1cf6d7ae5f8790f0adf57a186d1a75604ada75feae4f43a8911bbefa4b67748"
    sha256 cellar: :any,                 x86_64_linux:  "fe1ffa216cee5838b8e00d710a68a2119ce4cd6fefbc7307dbbdcbb354e6f5ac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
