class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "d18f253a50323a873eaffc54badbca22cf38c27f3ac67a1cd7cdfb364210d933"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b831bcdc70cc5d361f7fe9ed23c41bc0f351b2ea5e3d85ab0188f670dd4faae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f64fa6756f6ade575c52ba814ccd8ac9515b21ba527bb70a7bb25cbd02a8d36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e77cf2ead7a0c933169dfcf956b155a3f7018e4730b458ec9b246f414b52424"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81f0a506c3ec566ce44611fbf7382b5a78964f58fbdc9e61fa5b7cbdc9347457"
    sha256 cellar: :any,                 x86_64_linux:  "406f2d43cecf509d1dc374a366d6e81017ce6fd73234369c2b97368e87046951"
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
