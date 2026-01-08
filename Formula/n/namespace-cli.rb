class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.466",
      revision: "0cfa9c9cf5a6ae0145ae04d6ec2a94dc10d95818"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bb32e4d9f7ebb0425271b70568e20e82af2668b1d080c9ada9962bf799305d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bb32e4d9f7ebb0425271b70568e20e82af2668b1d080c9ada9962bf799305d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bb32e4d9f7ebb0425271b70568e20e82af2668b1d080c9ada9962bf799305d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6d0431b9eca1f9e16e3abe728360572d1e3cc9d1f4d4cb37dae2d2181eaedbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d025f27204a647e9d2c604e8cc12028e1655d86ab75d0b010e17bb002a52cfb1"
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
