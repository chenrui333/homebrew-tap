class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.556",
      revision: "da630dcd8e336f91e186bdae2d81aefe0e835492"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2349b53b214269b9e3a48ded95843dc9063a99a11e708ec1d305d4bb5e20344b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2349b53b214269b9e3a48ded95843dc9063a99a11e708ec1d305d4bb5e20344b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2349b53b214269b9e3a48ded95843dc9063a99a11e708ec1d305d4bb5e20344b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8283b99958d51d56eabf691409066638df0c889f6b8d8fcedb9620d4e72991f"
    sha256 cellar: :any,                 x86_64_linux:  "e22d3f05ab3fe3ee0354776d98b752114902a7d2f3b437b21502913bef58c6f9"
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
