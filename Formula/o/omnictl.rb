class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "23f0f4b5507e68e1a63e211105233e4a9fcd5787719210d6a9a4a5dac08d787d"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05580e2b177d53c50b456370121064ac1176fe637da0b7cd7102d49c8e418d93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "236b085bfdcad83edd0d0ac6158304f41d536254116b4213e71356844d37b9ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ab516298393184e5b67f159901530740185e6c52d6ad6d3440ac448af002d76"
    sha256 cellar: :any,                 x86_64_linux:  "d5a548bd9fdf373a77302b458dc89edccfd060c79dbd72a68f08dd28ce47ab89"
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
