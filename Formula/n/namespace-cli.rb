class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.516",
      revision: "5ac94919ec55a1cd268215ed0578ed887067d97c"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8245f461d47e6128c4665a63290e56a875428f4147e15d4c1abe8e486787afe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d94d604798696ad13e957627c167c816b9ae9061d41ba42c95a8af08e842f437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df95b96187f9e48a9187b3b8c69e752498b31d973ae7c7a4243f3b6d566135ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7aa8e5467138c7661acd4333d5da9c135139d488539a815be4f82a033fbb2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c7ff819b93c549101d88571e58a63a961f6a0ace855014ba6dd1f0a0037816e"
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
