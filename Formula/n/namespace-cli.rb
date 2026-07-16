class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.545",
      revision: "c9432e87b3aafde24c4518cb84fef87516a1ef48"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63f6cfea213afd0d98c8190cd0f1b5562eee08e85c37693096aedd3c776d33e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63f6cfea213afd0d98c8190cd0f1b5562eee08e85c37693096aedd3c776d33e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63f6cfea213afd0d98c8190cd0f1b5562eee08e85c37693096aedd3c776d33e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c122757d6d24877c8d77fe6a840fc4c4ddb2224a18eb3b9e9cf7494f1c2ce88"
    sha256 cellar: :any,                 x86_64_linux:  "3b1ced5dbc264e92db2aff200baedccfb3140eab121de1e30d4d52c08bcdd936"
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
