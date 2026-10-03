class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.586",
      revision: "b4f7606858e9f9420a828cccb7af506509f0e06d"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c91b8da39fd36b7d0b4d5c602baa3ddba8b0225330338d426306f5d744fe59db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91b8da39fd36b7d0b4d5c602baa3ddba8b0225330338d426306f5d744fe59db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22427eac26c57d87f0165e359e0181d1ea9cd92d0d9ae3fd9b32f17b0f539505"
    sha256 cellar: :any,                 x86_64_linux:  "f87e6d70d5992107b16b44fb2bf01d2395064de06c8fb9de3937b3d82e615882"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "not logged in", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
