class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.10.6.tar.gz"
  sha256 "b52a7d063249fc2de1d1d5e18ea881c9608a8e33af61c318a30fd2376892d963"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e990af23edaa8df03ed9a96de423838f781140f2be9360fd9fe5cd5cea169600"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723e3d66ab2dbe42914060bcd7460c0312351fd7e36a1ed0e1a4134fd05280f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd7dee7763b32d2f8ceb2152c6ac1ce2b5f598795651575940faebdaf928a500"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52c4dbcf216889926fcf02430d40379b07f25d8c104afe162bd8efec83eb486e"
    sha256 cellar: :any,                 x86_64_linux:  "8ba7151fef89995f538b3807761ddfeb5e6940207aa1fecc193295b1f96df9cf"
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
