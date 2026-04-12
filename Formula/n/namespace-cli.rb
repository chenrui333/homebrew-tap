class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.498",
      revision: "f83d1988afa1c3bb7b7efe60c1be93d5651ce502"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cd26af4370f35386f07285132ed52881efb6a0a175911d89a6da82189eca27f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cd26af4370f35386f07285132ed52881efb6a0a175911d89a6da82189eca27f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cd26af4370f35386f07285132ed52881efb6a0a175911d89a6da82189eca27f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2d8f68596f7e49c720495f0018a3ac0b92e427a70517e87a49e98ed66c2e843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3ca21e4a7f802110de4457596ca2e23cf7d96fe634bda518fe640dcbfe87a30"
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
