class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.476",
      revision: "a25fc11857cfa953f0a2c8ebe2e9d8af1226f212"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f70711288e119a90125f2cb50bbb34b5bc3946d3a00eae79564cc63fbb01580"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f70711288e119a90125f2cb50bbb34b5bc3946d3a00eae79564cc63fbb01580"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f70711288e119a90125f2cb50bbb34b5bc3946d3a00eae79564cc63fbb01580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44e29daf6494ab13873add3c493c18b850eef080e3caa0ed591b2c8399c45329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6acfdb79b300c5b386448cc149f4ae3b1d054bd2937ef437b3d5d344a91c50"
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
