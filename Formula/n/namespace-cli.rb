class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.499",
      revision: "809016e33ad3e3e9b798f1ce56be6781af001a39"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "502261217758c6e404f3a3db5324c596a0913f46830b7cb71a7fd4fc1dfc53ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "502261217758c6e404f3a3db5324c596a0913f46830b7cb71a7fd4fc1dfc53ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "502261217758c6e404f3a3db5324c596a0913f46830b7cb71a7fd4fc1dfc53ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "632d73a0d3f72166d81843c6cd06554cf5a9271b6080e10708c89123a9450883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db3d1441fdcedf9b2fb318b62a1ab7337c38349b93327ce248b1faf6431406b"
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
