class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.599",
      revision: "71db8318f0aaddbd4de47cfd93bad71438d2c1ca"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0d1724b6df1b1934235c93e9785bc3b1dc01e72604f4884f3c0c9b8a5990d85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0d1724b6df1b1934235c93e9785bc3b1dc01e72604f4884f3c0c9b8a5990d85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf90b580b0704f05a293e3a76f63296149aa9061f502a6f4dcbe8789dcc2af0c"
    sha256 cellar: :any,                 x86_64_linux:  "ad0da02c901cf636578a3652b9e373a9107a4da2a192ef105ef3694a5d1463c9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "not logged in", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
