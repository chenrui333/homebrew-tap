class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.468",
      revision: "42c6c91ec68660b107fdad5c1bb3d2325180250d"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f93881bb0fb361530b3116bf5a81956cc6bfa4c6788f82f2ccfe5796f4db0f8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f93881bb0fb361530b3116bf5a81956cc6bfa4c6788f82f2ccfe5796f4db0f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f93881bb0fb361530b3116bf5a81956cc6bfa4c6788f82f2ccfe5796f4db0f8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2784e82dc0fc45140b8ff7edda247e9841f422f657138aba7eae26bcf5436c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fd012b16ecf87a0f326022553efb343001070043e083c8b56cbb97c6e8348c1"
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
