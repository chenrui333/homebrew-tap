class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.542",
      revision: "e50d88d69a2274b75bafdbba8cf05ae97e36cca6"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be665a7485ed155e9f12b868747536ea38fcd0e673ba2fa51b21bc3c4685cd72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be665a7485ed155e9f12b868747536ea38fcd0e673ba2fa51b21bc3c4685cd72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be665a7485ed155e9f12b868747536ea38fcd0e673ba2fa51b21bc3c4685cd72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1777c06dee5cd999bd82d379b2890f5e07248f37a1fb9b87018f30ebf50a619"
    sha256 cellar: :any,                 x86_64_linux:  "d1eaab817c9e2c44b728c7d29815f5bad3023ddb9bade504a145cd55fa5ed42f"
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
