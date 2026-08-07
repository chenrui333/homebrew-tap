class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.554",
      revision: "5b0a5e205839466e1ee60fc2370ae526e794c312"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c63f9f5927e4fbc519c81bca9b2260873f5fe589b70ff8d4408878df22b226e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c63f9f5927e4fbc519c81bca9b2260873f5fe589b70ff8d4408878df22b226e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c63f9f5927e4fbc519c81bca9b2260873f5fe589b70ff8d4408878df22b226e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ad1975a56ec107d24e8e75808ad1657b7c9abf7ea0f74472db528c6d4b65ff"
    sha256 cellar: :any,                 x86_64_linux:  "dee67cd9f9bdbe32a9acae639b476fb89ff7d688f1c2a2e15b3a89a9cf43520b"
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
