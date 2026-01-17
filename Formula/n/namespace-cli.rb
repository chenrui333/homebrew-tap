class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.474",
      revision: "a861d7d14f8a9846a069f2cbd7207b958a418322"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f54d9fe750090040df82cece7d24cf597db48893c689ccf2e4ac079f43b0ebf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f54d9fe750090040df82cece7d24cf597db48893c689ccf2e4ac079f43b0ebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f54d9fe750090040df82cece7d24cf597db48893c689ccf2e4ac079f43b0ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72e277e1e1611d3ef0b757a7ded58a40016c925fc6c62f2d87e61beb6e86d97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d72327be74d47753c5c0c4a1f293fc42a0f280bf988afd8e7a66cfe33c8a46"
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
