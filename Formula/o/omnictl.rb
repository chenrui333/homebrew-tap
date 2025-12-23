class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "77a0af31644fcef53c51ddd821fca9e851c4928a69a1307d32dc82d3df0a99f8"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f291120a38506f6da6dea50098a6e3964d13b37561a126df78eeeb744ffc91e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f291120a38506f6da6dea50098a6e3964d13b37561a126df78eeeb744ffc91e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f291120a38506f6da6dea50098a6e3964d13b37561a126df78eeeb744ffc91e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27570e2b7291af98606139588d725967dbf732b1edbd11a4f525e3b872fb57ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "709cd3dc937102af191363234d5e7ed8e542e26d647fad10932e9b49c542f914"
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
