class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "21114d304517f24759e95e7a4bb3fc8e7b479023bfa128b55d1b362315311933"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18df18a7c4f34a972357b160113f056eab1973476222eab7e6c71f6fd10fd147"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18df18a7c4f34a972357b160113f056eab1973476222eab7e6c71f6fd10fd147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18df18a7c4f34a972357b160113f056eab1973476222eab7e6c71f6fd10fd147"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01f39a6d47d2681a459616f5b405653d6014770316f223edfb0aa95baae6e111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "229550c972407279db7e8abab7f2e608d4b1a5770ad8cb4dbbef4fe95e629b7d"
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
