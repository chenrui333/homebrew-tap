class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.541",
      revision: "89b9b02e59c1d9698ace4dcb4fa9086e407434e9"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b7fcb79871adbfa845097854d1dc5e31bb15a1e3a309acf2aec1e3fc720b348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b7fcb79871adbfa845097854d1dc5e31bb15a1e3a309acf2aec1e3fc720b348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b7fcb79871adbfa845097854d1dc5e31bb15a1e3a309acf2aec1e3fc720b348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af720d82909ed4bd471e7a952887197a5d3a192702e6927a0bd7dc2dc1eddf8f"
    sha256 cellar: :any,                 x86_64_linux:  "19d2eb4d900d510cc876deb5c7af5a60ffd268cc016efdc7112579bc6eb4563a"
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
