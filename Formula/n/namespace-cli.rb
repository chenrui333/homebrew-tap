class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.559",
      revision: "8f53ba50b40d09b7dbcc14bea6023f39391d1f91"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac150fca52a91e3d8ba3c1e098c80c9f75d9f24a18703ddbc0c8420adcd612fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac150fca52a91e3d8ba3c1e098c80c9f75d9f24a18703ddbc0c8420adcd612fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac150fca52a91e3d8ba3c1e098c80c9f75d9f24a18703ddbc0c8420adcd612fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23452a830185d861aa9087e0fe94459e9091ffdfe05e95244177d96b851a031f"
    sha256 cellar: :any,                 x86_64_linux:  "eae0667cc3154361367869c8a6512f74b726732a4161fbb6c0442c322fa7b7fd"
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
