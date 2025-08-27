class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "eff04137c1a73c0ae33c3a1eb8d2275005b202826557ed40cedaaec1828d73e8"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2615ce6d2dd6737802e6a2668e7ee1acfa97a4c597417e24daf3da00eeba5372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c70f51ff9c0687c0baff7cac3eb5e7fef05a1beb86c5ab9b05d5244d2ff63252"
    sha256 cellar: :any_skip_relocation, ventura:       "4d469e4175a4d1281bbc2ea7586082fd389d62c2f10a918cfdbe4b1300c4be06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a1ecd070e305f2243cb32c779bcb8db925ad90f8027bc16e558594644398f0c"
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
