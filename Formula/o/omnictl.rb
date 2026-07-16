class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "123ad8e2b8a52d3ae159cb13bce7dbf32d29c62436bc749e60d29eb8912eb14e"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd431c4af6d900a153e407b7175b749a6ab9303e58722ccad24498ce571dfe2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8540da74fa19cc706689a854b0676273c1209c0c696e53efdcf5362686ac4fa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cd457a4f4a111443726140d8736d2cdfea49b772b6f7caa5aee46b9eefbd810"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc5b930ff6f54704e217d14d5b1e5a5ce09ae863bbdffff26a52982947c0e9e5"
    sha256 cellar: :any,                 x86_64_linux:  "c2757c71fe8a59bd92a76300d222a558fa1b1e11fb5f11c9523bb2efec00ed4e"
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
