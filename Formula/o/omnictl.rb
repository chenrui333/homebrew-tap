class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "a2d436ffa0f3f2bafcfdc8a62d971aa868014030e57ab5e0f12b6e34eb83b773"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "fe45b0c6c66befa55921b158dd4c4fd3a628579c3f129af2d77fedaa80011b16"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbc38da38c148f8dc6da51c40b83b913b8e379f6eb35aeaa586aa5ce95dceaf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8ce7f117eed83036a95b7402e9e5aaad30d047f1b0e001222b11263768e017a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff40fd59dab52a1f12006a66eb6a28c9fd2d3e682e1f1006370c6b30efb190a2"
    sha256 cellar: :any,                 x86_64_linux:  "a9033b954306cce5ac5068ca05b6e77709373b9c71657129635da232fb5e30dc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    system bin/"omnictl", "config", "add", "staging", "--url", "https://omni.example.com"
    system bin/"omnictl", "config", "context", "staging"
    assert_match "Current context: staging", shell_output("#{bin}/omnictl config info")
    assert_match %r{\*\s+staging\s+https://omni\.example\.com}, shell_output("#{bin}/omnictl config contexts")
  end
end
