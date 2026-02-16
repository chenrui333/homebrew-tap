class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.485",
      revision: "cb94b9360fa8c2be21a0ccf88a61e8f2ed3e6348"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3103b98e36aac8c3bf937f815027a830ce652a034cff69aa59f933bd0da3ca1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3103b98e36aac8c3bf937f815027a830ce652a034cff69aa59f933bd0da3ca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3103b98e36aac8c3bf937f815027a830ce652a034cff69aa59f933bd0da3ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e62ef4cf81990339e6a0a0cbbd7c83c3f8809df04b5b5b89029fd4116e0e0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "047494105fe7aae2c132c65459fd9a5ce1899430d193544019f7f35fe36a923e"
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
