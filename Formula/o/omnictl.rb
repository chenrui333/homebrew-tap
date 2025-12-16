class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "41f4336c71cf8061f25fa67a9aebdc1da8ac162ece8cd932173b6d047b0a39a8"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ed280c87d6d20c471776ae0e61720cd21d3100fb6377e80b46c98cebb0a532c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ed280c87d6d20c471776ae0e61720cd21d3100fb6377e80b46c98cebb0a532c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ed280c87d6d20c471776ae0e61720cd21d3100fb6377e80b46c98cebb0a532c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5262da7b9d3f45e4e1ff80bc22da5eece37154e933608aaded3cab6b5b22f0f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e190a8f879dea76d3e4f2a4fcbe51b67282592ad3a8d32c6749fd52ac43cd2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", "completion")
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
