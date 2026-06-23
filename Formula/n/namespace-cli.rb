class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.528",
      revision: "1c8f7a5eeb7e37f8dad21556632f8199f08368d4"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26279f2b5eb60be25e7e9910cf25fdd96d5315f3a09486c4179a601875c786f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26279f2b5eb60be25e7e9910cf25fdd96d5315f3a09486c4179a601875c786f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26279f2b5eb60be25e7e9910cf25fdd96d5315f3a09486c4179a601875c786f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0e4728ab935bf04a6ed464a2135b827e08d11029ecaf148de74107fa8cbaea4"
    sha256 cellar: :any,                 x86_64_linux:  "3d691bf6a8d44199d1456f37c5c670eb0e23f2d3415de6c8f21b7f8359776a39"
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
