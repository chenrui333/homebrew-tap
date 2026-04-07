class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.495",
      revision: "59ba7e8e7640c42b5b33d88cd437e717e66f7525"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2614115bd58b3cbc7216f1bd8249aeb3270c4f840a472f8a9da4ccc7fedc1453"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2614115bd58b3cbc7216f1bd8249aeb3270c4f840a472f8a9da4ccc7fedc1453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2614115bd58b3cbc7216f1bd8249aeb3270c4f840a472f8a9da4ccc7fedc1453"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "522935d3704d69091115f6c37a4ce6fbde0844781961f89419d7732ad05bccd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "004ca04c42a7838f1546ed1fb42f85367f1f66f23b47f618245e5e949aac6182"
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
