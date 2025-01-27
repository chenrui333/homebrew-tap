class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "8e352a7970cf36bcbf9c632a639b4a3c097a72d9e94ff9462ca1cc0de0a04b6c"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b48882e9c9e9e63704248b23e8dc87f56c3bf9988f9635551dd495a52e601f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dde72a20f9cba9b01232a1c73edcaf8e745d3dc82e5c7d9b155cbfa537de84b9"
    sha256 cellar: :any_skip_relocation, ventura:       "1a5572f745c7e74915e83aae6ad85dad1e6749aed19901779fd724193c60bfc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ad9c58fe374ae25a0ed8ee7365487263d37a403e1727256b5648a808a80a33b"
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
