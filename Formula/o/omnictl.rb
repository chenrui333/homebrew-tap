class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.10.6.tar.gz"
  sha256 "b52a7d063249fc2de1d1d5e18ea881c9608a8e33af61c318a30fd2376892d963"
  license "BUSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cca4881d46412fc8cc9691578658489e0503d5dabef1c9d03a136f46694e1086"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bcdfb70b0739b807df8afbc92baf63fe110400aa466ef6f6a02e90bd73e5bc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f6efbfcbe9f77129a6cf0f2608a32ae6e423dc14bad8ba52c5a9c997990bbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24f7d79321301418e9fc46a58c7b890edc175874f86f5740bfaff4fe817989f1"
    sha256 cellar: :any,                 x86_64_linux:  "31dd6c1f33ec2f4b825c7505826166e1b5e4ce7271f1b2a35e45b10b7ffd1573"
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
