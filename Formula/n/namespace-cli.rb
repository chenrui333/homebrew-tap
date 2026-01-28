class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.476",
      revision: "a25fc11857cfa953f0a2c8ebe2e9d8af1226f212"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de039c1b567ebd962280c31b7bcc164d4bfa757d3d8a09ead83dbf12cef71a20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de039c1b567ebd962280c31b7bcc164d4bfa757d3d8a09ead83dbf12cef71a20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de039c1b567ebd962280c31b7bcc164d4bfa757d3d8a09ead83dbf12cef71a20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043be0b22d38ca83ffef2fbb46f01a32dcf2922d9531224a22c33e8c223abc10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc31b5d44b70667062b891ee7d284a63f30a47a8c760035bc8864973e5003e0"
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
