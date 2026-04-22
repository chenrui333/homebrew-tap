class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.502",
      revision: "544c2fd474dfa9dbec0787c2c4dea867062cc02e"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78aa959fc3727a32fffd70921201989ad98ff4c0c49a218ea18a55ecb712f007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78aa959fc3727a32fffd70921201989ad98ff4c0c49a218ea18a55ecb712f007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78aa959fc3727a32fffd70921201989ad98ff4c0c49a218ea18a55ecb712f007"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d6b2e6685e3a353bc7603a2b6c3880724621e9fc9e519f141c4d1543996cfe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a77fd7da3da73f9ff8941e1d2694a22680fcef90b8144bb53460ab3d4ac437a0"
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
