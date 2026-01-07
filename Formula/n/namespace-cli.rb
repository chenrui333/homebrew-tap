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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc48570b43a482eedee70b0f9a6a68e420143e6ecfb0c51f8f467ef6409b2036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc48570b43a482eedee70b0f9a6a68e420143e6ecfb0c51f8f467ef6409b2036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc48570b43a482eedee70b0f9a6a68e420143e6ecfb0c51f8f467ef6409b2036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "656cbfce6728ac50932747e842ad91e7e97e46d21bb202f546d70612fa72475a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00566afbf6de7af55bd791fa9c3533ae5560bec7e1245903cdaaa8d7f78977d6"
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
