class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "9b60a61edb017fd3ea248816fffa8c4438717092b221ee06da079d2a8822d1b2"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2274b0e4909c23056ac5061eb3b0000f9f403ca9d9d1e4179b6abaa55086a6ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2274b0e4909c23056ac5061eb3b0000f9f403ca9d9d1e4179b6abaa55086a6ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2274b0e4909c23056ac5061eb3b0000f9f403ca9d9d1e4179b6abaa55086a6ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a15a27b5a7c751e5a90fa1338d431dbfec3da5304fe4baf98deb0de1178f6daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c5221637e2da324a83f80ecece62b7645ab82bd57ccc4f7d8c190b7b299e3e6"
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
