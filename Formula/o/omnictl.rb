class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "9f9664ac5796c9b1390a53851ad9debd2e85e175153586605d347b40505a6753"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31c548f65e0e185488424b3d646cbaacac66fbdfd1115378dafbc25aba4a82a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80143b4802ab896b3d432ee3bd493d681c4480f08362ba929165fda73e775d08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d3df02e25ed48e4c81c74ee8cc639a2741a494283ec7f6460cf94ed61fc332b"
    sha256 cellar: :any,                 x86_64_linux:  "20999eed40a2c8efb5d62b86d246f1c90fcdf67ddc9577ea861f1d442f960057"
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
