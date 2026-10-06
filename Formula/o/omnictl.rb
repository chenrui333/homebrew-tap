class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "951be1cc42b7279056969794e820580976f9fbde8c14a2f118e19bb49fad6ea2"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26c5ac6165724ce69526db6cc0bb9a069a086eb07956220fc2d2ad32944e239a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d376097fb0f2e256696d8e11de442a4fa12a542f78a17668039f4ca12c5aba13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ae7a547cc2bd7a52d72f4fbec1f0976a1da43d29ab73d6e0eeefb3df67e6c7"
    sha256 cellar: :any,                 x86_64_linux:  "733202fa22e443906e916083090452ce7a1a3b601f3f0d9755adeb2f3f7cbb80"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

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
