class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.593",
      revision: "eac2801e89e53b985cd7852d39b58ddd15cdc7d2"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fdfa0b03bea44cb1a26fc3d32bedf6bd2c95d1955ec27551d35cf24690b47fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fdfa0b03bea44cb1a26fc3d32bedf6bd2c95d1955ec27551d35cf24690b47fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3f4e1ac85fa8747b5e2d8173c1321168d163855ae202f3018248506b0d7a745"
    sha256 cellar: :any,                 x86_64_linux:  "183f4aabd56cd23a6942facde6c7c56376d7b6628892be213a3424030e7fecd7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "not logged in", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
