class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.465",
      revision: "abcfb988295fc2b441ca63a312a18bb916943d2b"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5b4fbaed8492eb8882819ab58b3db76eab0d6f83423f70ada41a0b28191adc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5b4fbaed8492eb8882819ab58b3db76eab0d6f83423f70ada41a0b28191adc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b4fbaed8492eb8882819ab58b3db76eab0d6f83423f70ada41a0b28191adc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c77118647338e0590455d264032ee8e9511e3262ee28ee3b906f16f3aeea857c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "208fb456e51d93fe87381ef3b0bfe94ca11e812f645d756fc2c4a1e5fd403a14"
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
