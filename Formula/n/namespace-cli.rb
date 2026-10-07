class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.587",
      revision: "80c97767eedcca9088b9081c086d9ae3b49d3095"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55d82266c289d44e81cc45ff57291afa8c5289301b0bd8215d79937c323bae58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d82266c289d44e81cc45ff57291afa8c5289301b0bd8215d79937c323bae58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a91583dad11b17eaf7420f9f0163fc331f17eeb7939afe1868a95a99abc3674"
    sha256 cellar: :any,                 x86_64_linux:  "5269beb1ac6f653debfd62828820813f9cd945fd58f52368e550d6a253a3c8e8"
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
