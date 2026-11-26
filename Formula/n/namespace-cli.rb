class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.601",
      revision: "be8ccd230383897650cd12898b63198863debbd0"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "94fdd21588d77211f28bc095983427d4fc9ea5fa3b49dea9056b94a8d3f6140e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83f1d78f00ea8671cc55d7410386b5ab5615bddef70f306b7198b2e128a2e1f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83f1d78f00ea8671cc55d7410386b5ab5615bddef70f306b7198b2e128a2e1f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e352ae5b36243a478fb2a56802d310df7a0ce3d3145e8ba1f2dadf5fcf3492e4"
    sha256 cellar: :any,                 x86_64_linux:  "08fa00cfebb728b67433141e864b2f7a689b92e5a92dac9e77c3ec2f66b03c6c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "not logged in", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
