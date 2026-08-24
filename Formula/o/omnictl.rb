class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "71b0c85b45987e976f5959363eff95ef94f7c43b678cbcb12724bf7bab81e6b0"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8101d3f8c8ad0078363d5e107e23d459dfd775cd58f2234bcd837cdb5e723cd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "639374de80f21a9db400b81d8b475683d70cfb942762b03fe791186914e1d608"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ed07be32105a1155adbc4cbeb8083281a9ff49efbc684210be67c3dac513b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f00c6ca55dd257291203e2485dcd5120f57a14c3b7251fbac50c366539537e1f"
    sha256 cellar: :any,                 x86_64_linux:  "f50e57621af07ad7f9cff268a684df0eb6c90cbc0ffebc59cdd405e94ba8f52f"
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
