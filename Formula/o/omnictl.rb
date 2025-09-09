class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "54402e5f19811deb8400be4f4357f76751736aaae4866f555aa4d5cd4d17ef12"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3816b671e94d4ce686cbb28472e7ff3380b7c12c1e4cc02d2d335385082c66f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6fdacb79bbb61cdb8443d909c6218d63937989aeb58af28fbfacf19e6e6210c"
    sha256 cellar: :any_skip_relocation, ventura:       "daecc661be80cc0b5548e6c904b906acf438b462d7f3d406d4a7e2a54a64cc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14c679bcf40c7265aefca6e63189d597bc5904251dbe36011b487c70f5434e7"
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
