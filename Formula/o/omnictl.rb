class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "50850c027a79a75bef7549b02c1416468c03ef71f60268e5cc1bbe4474c88812"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "900d9e561fa7b1734cab218a1de7c625c611f115d8231b71795a5e9820ff9828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "900d9e561fa7b1734cab218a1de7c625c611f115d8231b71795a5e9820ff9828"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "900d9e561fa7b1734cab218a1de7c625c611f115d8231b71795a5e9820ff9828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8194cf069e72c3affaf24608538f054e31ccae15ec48c99fc8d455970b9f0fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3343a9df03c0c587a426f3326de9cc06cc546dbb09af8ae675053b2b7f21244a"
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
