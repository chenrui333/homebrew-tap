class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.597",
      revision: "d63914eb06a6c7e3aa976c563da589ca3306233c"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b590a1669c8b04cd9726041d4e1dac6d40edcd3bfaa286966c8e8314a2aaa312"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b590a1669c8b04cd9726041d4e1dac6d40edcd3bfaa286966c8e8314a2aaa312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8de77aaec8321e6bca2e6d5f0d3cde3fa431007cb16e618d79be5ab7ee4f3764"
    sha256 cellar: :any,                 x86_64_linux:  "35e7623fa4afa2417fb0211ceee788ec4c2a6323094848d02c64e3045de6a06d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "not logged in", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
