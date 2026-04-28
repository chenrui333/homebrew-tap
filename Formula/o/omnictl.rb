class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "08b5639f57fe5a664f69a7617d82b91500f79920e87c9dca7fe743f0a2d24200"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7999dc2227b0aec82d3ed18f60a9add51593211b11ba2c08207332de742e68f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e61446901736f7702a9b4a746ab8edd699ca4c94eec44202a9fad23b73253341"
    sha256 cellar: :any_skip_relocation, ventura:       "e66ff1aec53b44f72941562443a167610981f2d87715854eba23ae0eb246e6f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1824fd25a9703de02c11d9aa309afec625576d1d49e2bd875bd31a57e0d9b4d1"
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
