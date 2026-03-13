class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.11.tar.gz"
  sha256 "883084116e8bb3711d9403d03f90fd0d017c31ba4204c67e173537ed8d630f54"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9863f38a97960fb466c8483cccc27b7524b02da87d6ad265bc1de2632d6943f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9863f38a97960fb466c8483cccc27b7524b02da87d6ad265bc1de2632d6943f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9863f38a97960fb466c8483cccc27b7524b02da87d6ad265bc1de2632d6943f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aafeccc1fc5e5ec335a63f171ebd091a68ac05698ee7d5734db464fcd4ec30fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1644b420ca041fc745347037fa9ddad2c19cde5bce3149cd4647988cb160340"
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
