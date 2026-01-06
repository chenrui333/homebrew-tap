class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.461",
      revision: "b2d4890c7c4e2ec154852cf8c6dda067b6165e7b"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d347bc3c07d1a133c4d6b0ca92ce4807b9ee8bb4b7a3ca16b40291a2d302dc4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d347bc3c07d1a133c4d6b0ca92ce4807b9ee8bb4b7a3ca16b40291a2d302dc4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d347bc3c07d1a133c4d6b0ca92ce4807b9ee8bb4b7a3ca16b40291a2d302dc4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ce1ead13d5101d517d9c067a2cd8c08857f63eae22bc05960452a4334c2a996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04d7e7ff1e35d8c78d47cf3da4d70a17108b0de840561803b9fdd55bf72e76c9"
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
