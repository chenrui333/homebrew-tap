class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.9.tar.gz"
  sha256 "6e5ff0db076ce9fbec0e29ba88ae6efdf0b3f790c146e14ee2be8cb2ff05787b"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a994b27428507dced732b875e61750c76c1482472ac4b7fe04525dc4f2008c8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a994b27428507dced732b875e61750c76c1482472ac4b7fe04525dc4f2008c8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a994b27428507dced732b875e61750c76c1482472ac4b7fe04525dc4f2008c8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68c83e36ff3c1d3ac06ae200bfeba870307d1619fbb043142589d811e90b0379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d742c4b8ad0d4cf5bccb30ae05c6d77f0c20c2ec3ad2e029f2263755ffd05b77"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
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
