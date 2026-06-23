class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.527",
      revision: "c23c7fa1539c04baada776c991d997938c79ca96"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4efdf10c63b1768d5daa99aa7190116110c2ab91def7ff94db798cb1bdee41b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4efdf10c63b1768d5daa99aa7190116110c2ab91def7ff94db798cb1bdee41b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4efdf10c63b1768d5daa99aa7190116110c2ab91def7ff94db798cb1bdee41b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f579054cc617df3a4b868ce2ed9d7c7765f82263624d25dd9f7ca6136c3c145"
    sha256 cellar: :any,                 x86_64_linux:  "aa4b296777fb4d79157808582efc506cedaeca0a382d1f205ccdd0513736d5b5"
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
