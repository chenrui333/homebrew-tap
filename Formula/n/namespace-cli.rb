class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.586",
      revision: "b4f7606858e9f9420a828cccb7af506509f0e06d"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f10bcedb6e2b4a5c93f65e8e3e0571a41a5fce14c94ee072e17fcb627f11748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f10bcedb6e2b4a5c93f65e8e3e0571a41a5fce14c94ee072e17fcb627f11748"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b250813bcce7a3f8ebf8e29d6b1443d44e8fc4b32b13104bfd1634256fe5b3c4"
    sha256 cellar: :any,                 x86_64_linux:  "48b8424ce9f0ad30980010dabd9f84ee978907554aac1da9da19ebe9088914ef"
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
