class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.540",
      revision: "372c59c61ebe299e17ea7397643cc149bfcd48d0"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca5f7c5bfd178bf1b99720f4b5155793c7e5f28600780af87b4371c20a11dd1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca5f7c5bfd178bf1b99720f4b5155793c7e5f28600780af87b4371c20a11dd1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca5f7c5bfd178bf1b99720f4b5155793c7e5f28600780af87b4371c20a11dd1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7173c67b9426141ea847fc97e3a719a35c09ddff5851756ecd68b68812b87d3c"
    sha256 cellar: :any,                 x86_64_linux:  "da1353276d73cc0fee345e55070a4f5f75908da5200e32878fa5bd4342609d45"
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
