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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f96a349c8a8c2c3a3a00bae4aa3247abc03a263f6456a05b8539d37999cd1c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f96a349c8a8c2c3a3a00bae4aa3247abc03a263f6456a05b8539d37999cd1c5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cc445f73c0aadb7ffaff1c76d07c7f54951e3161eb76f80a4f0b40821721385"
    sha256 cellar: :any,                 x86_64_linux:  "75ee76536e8c1275a858740214a9d268fa44177c8fb0d37b2e961baeaf4b1654"
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
