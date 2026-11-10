class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.594",
      revision: "c3e2bde9ff3f3f60fcc79101b128624858a1e5b0"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "647b821fda9d7aa8b85a815c17620ef03c8198616fbffddb2e13c15683b90060"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "647b821fda9d7aa8b85a815c17620ef03c8198616fbffddb2e13c15683b90060"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19fc3451beca06c761d32522b811f3a33278dfbf2a49518b41ffb8315e609e40"
    sha256 cellar: :any,                 x86_64_linux:  "30802e33de9f9762eb83171015a3e3bdae44bb0baccad10cbe0bebe6349bf5ac"
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
