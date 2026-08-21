class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.558",
      revision: "7ce05e62ec3c3964d6430e479872217ed0f5f242"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "402b541df3fbfac4487fd23d90d83443042c557021aec25f861804312106614d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "402b541df3fbfac4487fd23d90d83443042c557021aec25f861804312106614d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "402b541df3fbfac4487fd23d90d83443042c557021aec25f861804312106614d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82cc447d4255a3307731ddf763f48acba6a8483d505f22caf5d2dc3218a1e262"
    sha256 cellar: :any,                 x86_64_linux:  "f3087011e3566ec2599dd8a6c73dcad66d27882cd454d5fae37e14fff760ec90"
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
