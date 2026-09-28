class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.580",
      revision: "1a85f6eda2e71c4baba43ba129cd2e8ffae28ebf"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "880939bd55232ee40db7d7e4790a3fbc8447ac57b429515624e87b1c60184cee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "880939bd55232ee40db7d7e4790a3fbc8447ac57b429515624e87b1c60184cee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7056f812fbf4b2098053a2b4cd1142af90ac379c8d5a9f41c1ada307a16503b3"
    sha256 cellar: :any,                 x86_64_linux:  "2bcf6bfdf72b60f1c42447a64c84616f6e225cbedd54e75849b01764fd0db100"
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
