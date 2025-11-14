class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "0788890dee48aaf04d12921862e9f24db2c475cedcc87adc56148dcb2b6f0a34"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc63b0e858271221a80a5d8a81eb94790e80e9fd241dc6dadea4f80ff591e10e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc63b0e858271221a80a5d8a81eb94790e80e9fd241dc6dadea4f80ff591e10e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc63b0e858271221a80a5d8a81eb94790e80e9fd241dc6dadea4f80ff591e10e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c524c0b95928bf34e3b774c3be702dca95b0cd491adb9ffc1cf606fa2e8f9693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "541eef914cfac972277ae04875623c368c5ed862db41c0c0954deff1de386fa6"
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
