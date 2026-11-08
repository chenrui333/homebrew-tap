class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "2dd44ae2d3b5b1e963a1a0e981bb376185319ccb4ced53e01e48f988ce19ebe7"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a66c45d4c1f8b2267e127ec5f596d1918b856d1c257299d73a546cbde351d1f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7899dbb6ea7a828dd0d33382b221b949a93033d11b73e44d208dbf15ae1c3e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2571e5484c619e3285163f5418de2b2bb9c9b9aa7b18707dd306c8f8b8d9729c"
    sha256 cellar: :any,                 x86_64_linux:  "76510f6e1818c450bc43e444cf22cb30eb137bf850fd8b715d9c74041805bbc1"
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
