class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.459",
      revision: "67f459224d8dde16590cd9cdd07159bd73a23842"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "869d1ddf64e5e7010bae629e75fac06b66713f033cc02e531b50ccf23fa4d815"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "869d1ddf64e5e7010bae629e75fac06b66713f033cc02e531b50ccf23fa4d815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "869d1ddf64e5e7010bae629e75fac06b66713f033cc02e531b50ccf23fa4d815"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe5f751ff9a3e850944a85da96a88977d25c776d77fed82a8304ba20e4fdca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51e7717a4996a534a04436def13156fb365d2e23703d63a77b4e3bdc229d3a0f"
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
