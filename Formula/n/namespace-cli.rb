class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.503",
      revision: "46d368585037a2f037163f45548620c23e9fe0a9"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b3ac2c81d3f650da48c87afce06415d45ac7159440b3fdf30959da8af03c358"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b3ac2c81d3f650da48c87afce06415d45ac7159440b3fdf30959da8af03c358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b3ac2c81d3f650da48c87afce06415d45ac7159440b3fdf30959da8af03c358"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1d566d9d939b5e08993895bffe90e57ff7d887955414c7038bdcde2d8e24251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923473f804c1f57b8a42192694b513d10f0c3444c9ae6e96ed438b96821dfc3d"
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
