class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.591",
      revision: "ffaa3daa59b239651a0510af455f2355750bfe89"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c0d58f7bfaedc3948b450d0778709a125949f85a02dc8cd2d3a247f59672afc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c0d58f7bfaedc3948b450d0778709a125949f85a02dc8cd2d3a247f59672afc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99de5396ad0279c9ce956286544e4030821a019a038b08288c9e1a023f75bc0e"
    sha256 cellar: :any,                 x86_64_linux:  "140c29ee42585ad42c454656cb0fef25a3eb72ece56d7a45708704debfcedfc1"
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
