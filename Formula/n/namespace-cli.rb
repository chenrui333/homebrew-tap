class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.592",
      revision: "c269fcb49bc485b119891a9bcabe3e9d9cfcb6a2"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41f3fb4777fa65f34123e63694f06200a99af433da40856c62bf711d237b3b34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41f3fb4777fa65f34123e63694f06200a99af433da40856c62bf711d237b3b34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95c8c3269a73d9f396617761fe527738a147e0e427f3ab411ededff4fbdfae70"
    sha256 cellar: :any,                 x86_64_linux:  "c0f2540829c27c14646030d29a8ae28b48cf67e1072781785f6ddfed81631333"
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
