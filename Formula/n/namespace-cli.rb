class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.551",
      revision: "2f4c728fd5f29c6f8d16420e5c31c32b2d981e70"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3830d75d3a78c379ec6948300e7a8f60ec3c3541ed6a855cf3fffdade3e4c7d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3830d75d3a78c379ec6948300e7a8f60ec3c3541ed6a855cf3fffdade3e4c7d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3830d75d3a78c379ec6948300e7a8f60ec3c3541ed6a855cf3fffdade3e4c7d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "595a0602b218f2ba4f4b6b6fd4741ee6f45ea5fee7a48a2617c3490103b3e8fd"
    sha256 cellar: :any,                 x86_64_linux:  "32607cbd4cab61675c1a28f92114196e9687be1f24af4c234383d57dd6934f25"
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
