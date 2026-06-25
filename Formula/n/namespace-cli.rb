class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.529",
      revision: "2d1f8186b3822947eae59a5d518bd195276caa15"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb2cc17e8b0d304a65d1849f48a09684b478bcbcfee6b31fbc666c45630b0a64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb2cc17e8b0d304a65d1849f48a09684b478bcbcfee6b31fbc666c45630b0a64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb2cc17e8b0d304a65d1849f48a09684b478bcbcfee6b31fbc666c45630b0a64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8807ac9dd2d977d0829ab4ff5da7c6a6df5bc3918fcf92fc130989ba90bbcc7"
    sha256 cellar: :any,                 x86_64_linux:  "035a8c8bda3adc3479dbd423067a315171b972e14f923eb04618e331f20f8020"
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
