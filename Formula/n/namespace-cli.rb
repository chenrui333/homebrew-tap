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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aae07f214da9c7b7d1b4226c669ecc47444d538a99437a41fa3e2da2f5c00894"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aae07f214da9c7b7d1b4226c669ecc47444d538a99437a41fa3e2da2f5c00894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85756cb2e2e178e87905214df888df2f6e0b9a3c070de961434ce868be9df88a"
    sha256 cellar: :any,                 x86_64_linux:  "96cf915be6d380755f7f88b909386625605f3e1312d49ba81b829bc1922a7339"
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
