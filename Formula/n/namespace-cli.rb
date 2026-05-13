class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.513",
      revision: "507d22be7e32458130f8dbe042aa041f09b70c35"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d602ded14307b84eb90647385f77d1ea988f5e7237d656a505af4aa6492831f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6ac5514f7e28adac74f6e309824d8cd88fd7b5310ca14e749e85d4033365d73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1f01ca1c04cb34d736e30fa7dbce917d4219ee09d1692b3d47ad571c1edb261"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0accd74784c48d8eb124926f39687a07e4f6918d3c87e008f8ec00cd17d141e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cafeebb1f8f890f03241f56ff3caac8cdf3a839d305fcbe6863b19e7dbfa68e3"
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
