class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.456",
      revision: "4abe8dd414c4ef6186ee914cc96cb45209ac1b08"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "608b440019c2c1e2b2dc48e126635d368ff09a2917fd5c3f7d3727cbe30a4a34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "608b440019c2c1e2b2dc48e126635d368ff09a2917fd5c3f7d3727cbe30a4a34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "608b440019c2c1e2b2dc48e126635d368ff09a2917fd5c3f7d3727cbe30a4a34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e4336401d601c46d1d8cfa8d06869d37d22f14eaea3b83f12ba92bc28439c83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffb1536ddbe3349ae384502ba16d6349318856e78b784bc6bbaff312ff3cbdff"
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
