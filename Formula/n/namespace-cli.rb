class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.588",
      revision: "9955946a9b7725f38c366d58a584bcf91cf003ee"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb98396a15edb368b6fb26028201c9438dfb5051dd37b774018200a1e8acf757"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb98396a15edb368b6fb26028201c9438dfb5051dd37b774018200a1e8acf757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a995a4208342eae1055512408bc529f9b7fbbded515a462df459958ee0ab5256"
    sha256 cellar: :any,                 x86_64_linux:  "f71bcfa8d54b6032c78d9b406510eb0f290b63edbfb05a11ceb45310d28b9da5"
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
