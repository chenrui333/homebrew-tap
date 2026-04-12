class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.498",
      revision: "f83d1988afa1c3bb7b7efe60c1be93d5651ce502"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37d78f65bafadb12f972404fc74434952bee3594358055650cc7dcea7182b698"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37d78f65bafadb12f972404fc74434952bee3594358055650cc7dcea7182b698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37d78f65bafadb12f972404fc74434952bee3594358055650cc7dcea7182b698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0c053596b0fcdf4d901bbf43cb2d55ec787a24a0efed7de83069da84c311941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbd36f147912eb0d5d599fddc02b985f046120a771171ff804e9808305c9b38"
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
