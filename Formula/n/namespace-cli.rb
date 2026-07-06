class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.532",
      revision: "8fd20e2be4ee9d72b1357fa6f8ff2e15629abc96"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae677c273aeaf95e426b1e4509504e6f1a422d9222560f4305bf322633e8be46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae677c273aeaf95e426b1e4509504e6f1a422d9222560f4305bf322633e8be46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae677c273aeaf95e426b1e4509504e6f1a422d9222560f4305bf322633e8be46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44bc49f66af2e5597f56ae44f561f31d71227fbba3ce9cb278ad7eb75d234ee3"
    sha256 cellar: :any,                 x86_64_linux:  "cdb2ae83aabc20e1531c864b2829d8b42ef117d38c174ca8565b98dc81f053ab"
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
