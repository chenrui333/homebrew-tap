class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.454",
      revision: "629658c6047fc790c935df6515ad8c8ed9e5e16f"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89a9c2f0b74ffb21a6a8d6ff00c4343fb646cd51a3f952612c694be6fb9d57a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89a9c2f0b74ffb21a6a8d6ff00c4343fb646cd51a3f952612c694be6fb9d57a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89a9c2f0b74ffb21a6a8d6ff00c4343fb646cd51a3f952612c694be6fb9d57a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "235e940aa9486fdef0f4c4f6994d392b00f055e541ba9f9a3deee3197072df8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6022fcb6c7bd42f4121f099ba2778515d8b2a9219af99653f52715000b6f5a35"
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
