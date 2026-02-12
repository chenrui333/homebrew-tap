class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.482",
      revision: "c9f0cb9f24bb0926971f40563339e935c0027acc"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9735839942f72db2cf918c0ed2658b19d71983d47f51cfd31b72a847e8bc443"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9735839942f72db2cf918c0ed2658b19d71983d47f51cfd31b72a847e8bc443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9735839942f72db2cf918c0ed2658b19d71983d47f51cfd31b72a847e8bc443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934ccf2d5cf3652967871f59025ea906b88c854187a6cc65f3f847a3b89dd0b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f27b895fc89218bedc6bcba5c9710cd1fe9642996e96124c1fc44fa778be1b3"
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
