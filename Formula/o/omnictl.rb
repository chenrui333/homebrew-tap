class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "a9ccb6cd2fb489d2ec0b5f11bf2f830ebff58e86a548eff00f5f0027403afa82"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57874c6a45836d615f12f0de3c0aaa8af1116c3cc10d29a39f563a7aa80a38b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57874c6a45836d615f12f0de3c0aaa8af1116c3cc10d29a39f563a7aa80a38b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57874c6a45836d615f12f0de3c0aaa8af1116c3cc10d29a39f563a7aa80a38b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfb8a4406ae916a6013be5b1b4924ef7821b4f789cdbffa009c75378362ecaa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c4dfe87b0da27d9836fb11fedaa47f4092d1e1e8738717f46f1a10852c273cb"
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
