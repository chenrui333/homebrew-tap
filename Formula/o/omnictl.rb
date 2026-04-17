class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "07dd01d8d724f59697e2754027dcbd12ee6e5bf2da1348e5b32d844e7eef4288"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab82c5bf7a975c90718ce89ff113d668390f07eba77ad8c9f3de369405a0dc35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab82c5bf7a975c90718ce89ff113d668390f07eba77ad8c9f3de369405a0dc35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab82c5bf7a975c90718ce89ff113d668390f07eba77ad8c9f3de369405a0dc35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ef96d1416f3b839da78399d98b030a804719ddbc6d6cabebb04cfa6d8453171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d4549b06c9b0990788d4b398a6ec379d9f9c5e96ec2cefa0e7310723b77c20a"
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
