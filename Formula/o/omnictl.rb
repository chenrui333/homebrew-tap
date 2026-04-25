class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "1739fdf188c623af85e01e20e61400e3848824200ded8be28fe6de7afe824494"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f59891a1ac1a8a9ac0113df36d78ce565e1ac538e33889b5cd602f157533c22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13ad65860e32efa406e4a4ee012c1c26963403bb88d3a955382be3cf92848307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e50b39ce1a75bea39f9688aceec1d48fed1a86f95c09fc036c9e7d69ea9c2873"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b889a2e501c28b3ddf023b0bb9780a21ff7e02e1ec42ac058fb2ada86e41f27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aee5d2cf0f613df0615d63fdbe2dde331a1a2fbe27448d382a5da293b102d397"
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
