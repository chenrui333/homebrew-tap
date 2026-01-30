class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.477",
      revision: "0ae2770e183deb94562798b064b8ef9876a20203"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bf314db4b4a4ba377b1da499ef023e2182786de64520cbe0e3b890fcc2a6dbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bf314db4b4a4ba377b1da499ef023e2182786de64520cbe0e3b890fcc2a6dbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bf314db4b4a4ba377b1da499ef023e2182786de64520cbe0e3b890fcc2a6dbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "028aba2fa47a86adc5a9841ac7771cce259ca327cff3c4cf5e10c8096b24beee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ee646738846a002edf7c32a79322b227894fb388758c3539ce8da85b3b7e4eb"
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
