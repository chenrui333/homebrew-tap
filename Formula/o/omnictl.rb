class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "51113558baab2d4da92ae71099e6f811f511fc491f732e077e828a07c48da7b2"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e969c8a6ae94f2eea50268fd00d976bc4f1920ca9541450db1e2f5bffce8767"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e969c8a6ae94f2eea50268fd00d976bc4f1920ca9541450db1e2f5bffce8767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e969c8a6ae94f2eea50268fd00d976bc4f1920ca9541450db1e2f5bffce8767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b143bbd712319b0cdf6961da1a541ef446294c1dd54818351cfcb5f59b2320c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "481ce41e07b8e5c34aa14481959331763d98e9a7c4e37da14705987fd39d157a"
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
