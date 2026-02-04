class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.479",
      revision: "c31c499eb37b2e46c778d8133d0276c16d5795f1"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e6b209afbf05df37c61c613cb7bc7065c76f978bf1324a4e72e84e064ef4adc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e6b209afbf05df37c61c613cb7bc7065c76f978bf1324a4e72e84e064ef4adc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e6b209afbf05df37c61c613cb7bc7065c76f978bf1324a4e72e84e064ef4adc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e91e2c2c1725370a05f33fdf25c7851d9ee1a9baea5c88768b78aded01a2b098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "355f7e723aaa67a51463cf6fc6c1df51e68fa276eeb8c2e98d63cf02ae859f3c"
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
