class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "eee709782006e4a60881cafe16ff01cf4f1974b0f57ddb35be8ed7d40a8b6de1"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4943e2a1137f15ac93fa8f03efc8c50c78e7dd4a0d2e07a1bdb5ff09b59c1b93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4d92ba76b71ae8d8acf44dd6d9df1caf615636559377c31690bb2e8d2537064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a206e4b9e77897d16c068569aa1032b48e43ecf58d8346833f3a41cd227f597e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b24d5ad8fd77568997d55fd3d9ceed52fae0824f8df8b4c0ae4e6fec0c5786d2"
    sha256 cellar: :any,                 x86_64_linux:  "c771381d9e7b73f80763c9296d6e9e832b04147a5780af5dca458106322d8e39"
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
