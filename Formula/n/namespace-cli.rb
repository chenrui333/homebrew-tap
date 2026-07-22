class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.549",
      revision: "c103abfcb60d0d50bc2e0d53a01c22457afc15af"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09d5b79da4ceef212a42a9946fef8c312f4b12961277b0ff537828c3a8ff7ca8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09d5b79da4ceef212a42a9946fef8c312f4b12961277b0ff537828c3a8ff7ca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09d5b79da4ceef212a42a9946fef8c312f4b12961277b0ff537828c3a8ff7ca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76d19582a0ba5aec0780b436b0088d38fd22ca6278e2b60ca90e531c7ee1f1af"
    sha256 cellar: :any,                 x86_64_linux:  "1122ddee15bcd9c22895f040b624ab5c77817aa1f294cf61ebe41232fa367454"
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
