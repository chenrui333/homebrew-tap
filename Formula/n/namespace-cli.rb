class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.574",
      revision: "71a39cdc36c66e27a734a084b1f008067fc1bce1"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f40f275691ecdb8d49776bba08208aeaafe77cde1c99a09eefaab317dab8469"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f40f275691ecdb8d49776bba08208aeaafe77cde1c99a09eefaab317dab8469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "799d66db1af041f8861fd336f93666ef1d4d752676a3092fab8c6bcc4693ae0d"
    sha256 cellar: :any,                 x86_64_linux:  "eaa37fff0910192b8e086c1f2d05858696cb9a078de463a18c7712325219cfc3"
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
