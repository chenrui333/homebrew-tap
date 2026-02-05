class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "f5a5fd84ad2d6da84d39a60f63bbef81bb672bb644e361ec46fa4e933b218b72"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17480b624437e6e3e55f69a1ca0b4dacb8eff102a1411126cfd2d6f66401e6c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17480b624437e6e3e55f69a1ca0b4dacb8eff102a1411126cfd2d6f66401e6c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17480b624437e6e3e55f69a1ca0b4dacb8eff102a1411126cfd2d6f66401e6c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08a199a225c34a09f4bc5aae8f199d47eeaa4d7842666eedeed5ed19a2fff236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26884ab0d19564b4f47f87fc0ef01f3b033908954263036daea398b88333bf5d"
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
