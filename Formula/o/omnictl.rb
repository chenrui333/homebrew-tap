class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "9f9664ac5796c9b1390a53851ad9debd2e85e175153586605d347b40505a6753"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8c90ca90386fa707a8d6cd694035f597b8cda6bfe9c4ee3261bf6c6e2c28d39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4817b4ba1d59862b0f45219cbdbb769eb1a222084b5ab386be378cbf5e79183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "627636b96f52696542ebeb138524bcd36206990f569bffa53602f432af859e6e"
    sha256 cellar: :any,                 x86_64_linux:  "1b75f52adb475222a88e514c27c8e34fc4f49dbbd0666fcc98ed5199e2c7d334"
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
