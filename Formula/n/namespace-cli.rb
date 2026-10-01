class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.583",
      revision: "82fb2a9819a434ce47b7b80cca8ee8babfbd7c65"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dbf99881bd3c72d972794e42fc3710ae66b2500c34c5edf60725e31080cf9cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dbf99881bd3c72d972794e42fc3710ae66b2500c34c5edf60725e31080cf9cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1e59636f692f59726bacb8ce4e6569a4cbd71e37dd550352c43d7c3aed7e27e"
    sha256 cellar: :any,                 x86_64_linux:  "1cae0acf3fce000878c3111cc3a71835aeead903cfdf864e7425013a4b213799"
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
