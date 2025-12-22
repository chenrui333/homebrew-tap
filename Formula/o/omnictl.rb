class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "9f72cecee8f38484649c90ad16d028faf227c07347299533bf882db9249f6a82"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed55b8b8685ca33f7f945c6d32b4bef281538d19fe1a3a4d9ed6d878bf0f5f14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed55b8b8685ca33f7f945c6d32b4bef281538d19fe1a3a4d9ed6d878bf0f5f14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed55b8b8685ca33f7f945c6d32b4bef281538d19fe1a3a4d9ed6d878bf0f5f14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8760beb9fbc3fbcdc67fadb7613f69f47b88f46507125370e87fe862caa02943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a269ac3f29f90c916262d0c259bf36e7d96eaef2fbf35cb28aa8818ca05f0055"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", "completion")
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
