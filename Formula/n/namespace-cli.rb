class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.502",
      revision: "544c2fd474dfa9dbec0787c2c4dea867062cc02e"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45a8d59ed30989ab8e39071ea0ba2a44548f95a2360f020ea4b0fdc65e1b279f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45a8d59ed30989ab8e39071ea0ba2a44548f95a2360f020ea4b0fdc65e1b279f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45a8d59ed30989ab8e39071ea0ba2a44548f95a2360f020ea4b0fdc65e1b279f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25e622381419e0d012913bed07b04f68fa7f40a655406d6a934d599476138e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed4f7a85abcc7bc5b4b94be3a4493525a5c4a2c3326c39f11fa4e780a6111a0a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "failed to get authentication token", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
