class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "91694fed6ca74416be35befe4f001bf3b45e973310e84ac7f8d0cdd851f565bf"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab7ffa52481d372ef6ef4de9e4139d59f2f3f0e4a5fc009a51c62b49fe8f2fbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cea94fa26fa16427f7ce1882758e8055ba84dd185475b9cef19afb8b46df1cd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95349a8e86c1a688a29f7664fd326a5334112193ef3c17d733aaf10686d664f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "280b879ee4fba7a6a0babd0253c8525de4bbeb32a384b583fa00cc87d5f82a69"
    sha256 cellar: :any,                 x86_64_linux:  "70a00bfb7cb2bf416dc98a0300f1e48a0aa6c1932be3e0ecf90380621ded41a1"
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
