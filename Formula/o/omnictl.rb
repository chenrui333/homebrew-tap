class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "8e5273bba7cd7e2e3d9c85e84eb093bbc83c9b4d5dffa9ede4c692d6e729b933"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b6d1a830637b06ef1e8ca31b00be01e379f14c92223ac99bc556c9db9ee89ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a22984772e05ed6989f2e225b22023b598f87a410830176e1bd4a60c7db0872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b4e291bb77cd49ceb1fcce6365e1acb6f5ceebc5cc1a0c146bf5f485e611da2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abd87038ab436f5208961cb0d8a716f752b5b30343cca9cefbdc083d7e18279d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "437be705eaf3bde5e459cf67946785f06a5e4f6c2f186aab5e0877c7b87a63ae"
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
