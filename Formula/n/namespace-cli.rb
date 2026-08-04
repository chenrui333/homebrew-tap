class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.553",
      revision: "02181942cf8db4e031ab4e39e9109746f42062c7"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c05fee55ea1b627f8d83beae7ec89be887b959b1d8be4446fbd333803b1a963a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c05fee55ea1b627f8d83beae7ec89be887b959b1d8be4446fbd333803b1a963a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c05fee55ea1b627f8d83beae7ec89be887b959b1d8be4446fbd333803b1a963a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39af60a6ff186fcf3f1b0acd56f89a10e82983c92ea49008acd8b18b1a8ea1e7"
    sha256 cellar: :any,                 x86_64_linux:  "e7eb59df90e733ab3ab3ccb67af4e757bded4cc194e936cd1b296b60720ffa3e"
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
