class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.561",
      revision: "4c3442724f861077e51c3bb14d102b1ab349b72e"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e236daf95979fb93c18d920425b29779e706a2cf9a5930863bfc9806239f016"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e236daf95979fb93c18d920425b29779e706a2cf9a5930863bfc9806239f016"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e236daf95979fb93c18d920425b29779e706a2cf9a5930863bfc9806239f016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1feecdf8010388fe5e190ad00c4e441a84a6af4ab25699b0ce814b4f3cf524e3"
    sha256 cellar: :any,                 x86_64_linux:  "3e2ca95abcfe9b6011b896f6ba6a54ed9d294adf5c20ce38a2e6cf943b4192c3"
  end

  depends_on "go" => :build

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
