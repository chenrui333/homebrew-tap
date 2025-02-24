class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "c0294860af5a591aa644c999d634a1c724ebf6deaa1e40eeaf021a2b2e67c9b2"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53347cedd08c01c29c1f18799fd5ddaa85f96fc06fb203383898cded3ec017ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99ede225ab6c16417a4a1f461ca93f7f583b60cc852fda1505764e8175b29100"
    sha256 cellar: :any_skip_relocation, ventura:       "c45ef52a14a7ef28742585dd3e4f26b4c80ed88c432cfefe6cc712007e436e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14e3891d1a27ca9863d23cc03aac960a25d5a3dc3554bc59e58d8f33fbc7e9ff"
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
