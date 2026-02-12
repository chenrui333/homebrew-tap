class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.481",
      revision: "be34d6c2c512d3617df3631907d818f14cc0ef51"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7ddd6e32563209ba37ad58dc765f6f4a031f545881e970dcbcda364a80e0c00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7ddd6e32563209ba37ad58dc765f6f4a031f545881e970dcbcda364a80e0c00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7ddd6e32563209ba37ad58dc765f6f4a031f545881e970dcbcda364a80e0c00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5697e3e735eef6f78122c18058ca3eb6051a206194bd31c1c2c3520f8f592aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c93ba3af8e6ecfa16ef15a9267ee2d2fd5a8bca8302977294b1d1083bcf5d833"
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
