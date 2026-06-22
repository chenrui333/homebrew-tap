class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.526",
      revision: "c9aba12c3e8efb8edf00394bb51045526cdd94df"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "981ed9455a6cd7d2f8ca08f7b77d08e30d72f1397ef92b66ebe0ae11d8450f88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "981ed9455a6cd7d2f8ca08f7b77d08e30d72f1397ef92b66ebe0ae11d8450f88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "981ed9455a6cd7d2f8ca08f7b77d08e30d72f1397ef92b66ebe0ae11d8450f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "406484ca6c1dc7df908c88ed602f6eba614c4e4656c75b5a28c9856e0bb4ccfb"
    sha256 cellar: :any,                 x86_64_linux:  "7071647e23f8d2ae0a1ee8849f7a100a3a094d01f1918863a81e31a1c6f8c72b"
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
