class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.48.2.tar.gz"
  sha256 "bc7631d0f1383245e07f12277b3f79ac5483c17b0b5238f8036827333cd0e25e"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b82295a650cdcaab045da8092d04233cd10509e2a3ce494adf0bcd69baae9ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1854bcc0953350727b48fe7a685a85042e23c01e81d603014b01f852e90412bf"
    sha256 cellar: :any_skip_relocation, ventura:       "2aa6b3583837721e88e0b6b5f92b7bb8036fcde5e31c172f01b8ad276d4957b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fed8136f38ce9e03ff74b4fbaa0eb29d790b65a89e7ac52252533edba49786cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
