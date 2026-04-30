class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.505",
      revision: "284b70c0d0cec2486f4833aab13d6e755067fe9f"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89e830c94c68f34ed634669f2d60d2408c9bcb280d4f5994df9930ccc11d2d1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89e830c94c68f34ed634669f2d60d2408c9bcb280d4f5994df9930ccc11d2d1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89e830c94c68f34ed634669f2d60d2408c9bcb280d4f5994df9930ccc11d2d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86a14e9e9f758481d964c17f1facdf1332ab08ee3f55b88ac03e253192f47843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cae9e9674ef3138b657c8cd3a941d9d765050c8250869a345becc73ce0a76ca"
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
