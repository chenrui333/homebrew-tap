class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.492",
      revision: "916b454299ba8a6c74aa0972defd7a8007b892d9"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22fda160737da8051c021edcfe9661c6b61faf80449e9201c9bab3cd54397537"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22fda160737da8051c021edcfe9661c6b61faf80449e9201c9bab3cd54397537"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22fda160737da8051c021edcfe9661c6b61faf80449e9201c9bab3cd54397537"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d9224e7d2cf9ead5272296244cda98f285a9d796a0aa93759b62b818bfefee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "502625cd6822bd3a3b4461fa9715759e1fc6e9f3518959fb8f93103bdb31f90e"
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
