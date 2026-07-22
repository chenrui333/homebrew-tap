class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.549",
      revision: "c103abfcb60d0d50bc2e0d53a01c22457afc15af"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c50afad12f5ddad48cc47936e85b9d0da26256daeb27b01f6bbdecb737749573"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c50afad12f5ddad48cc47936e85b9d0da26256daeb27b01f6bbdecb737749573"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c50afad12f5ddad48cc47936e85b9d0da26256daeb27b01f6bbdecb737749573"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be116d633f210f815ccbf68df2205e9bc6435445a572ac0f74528fa1a6962ad5"
    sha256 cellar: :any,                 x86_64_linux:  "c0da27b8448381f617b3130623b5a56441cc4c4d43b65bac9e44e29489873ca5"
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
