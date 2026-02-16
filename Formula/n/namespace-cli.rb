class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.485",
      revision: "cb94b9360fa8c2be21a0ccf88a61e8f2ed3e6348"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8874292f0d42ed4923104fde703c1c57691996017d1d53937b60ab0b702bf8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8874292f0d42ed4923104fde703c1c57691996017d1d53937b60ab0b702bf8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8874292f0d42ed4923104fde703c1c57691996017d1d53937b60ab0b702bf8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc6a488ce0811f3b02844394b3a7fbefabda02b3646e71c4890b79c3427ad294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c03931d8ee03bcd13e1c835e4ae2fe5fc81d9a225daea64f3f1976531540851"
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
