class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.455",
      revision: "d3826cd5c57ed3c1de9c2ca1583939ed5dc09a08"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b14537f76c70af5cec09a90c09ae76c18b89181954b50b4f39e4d141610dbf21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b14537f76c70af5cec09a90c09ae76c18b89181954b50b4f39e4d141610dbf21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14537f76c70af5cec09a90c09ae76c18b89181954b50b4f39e4d141610dbf21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b4789a713f655c834ad3c36f77080c43bf7fba9e950a892889d8c78de43d997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6da58f4c441b4dde8cc3b53b90fd0aa65b9e3621134d3d164204c8252bc2f185"
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
