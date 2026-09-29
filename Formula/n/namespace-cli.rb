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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "380d7b3d8d020ea638e00b3bc919016630065bdc5ee7099c163d091259dec5ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "380d7b3d8d020ea638e00b3bc919016630065bdc5ee7099c163d091259dec5ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0669dc240aa33e71f77a02c45ceb5e51343f5f26130a6a58c93fcc6b71b98052"
    sha256 cellar: :any,                 x86_64_linux:  "dcfd6150695ad89d7a79ef91a9d4c74a25df81d305a9afe8cf15af6ae90ea636"
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
