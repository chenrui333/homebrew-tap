class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.581",
      revision: "b166f1de40081d4c27b23990aad736abf076e4e0"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34673dbb598317a04ac90e2a6b1aba0c0b638feef57499dd2770f5a85bb8cfaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34673dbb598317a04ac90e2a6b1aba0c0b638feef57499dd2770f5a85bb8cfaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b070aff65c679cca40f901b9fa546e3bdd451f52c79dd8060a67fbfe6a2af7e0"
    sha256 cellar: :any,                 x86_64_linux:  "b1e0668301b762bffb64dd971fab53110a5e0d7298c320dfd40f98455adbc1b3"
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
