class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.593",
      revision: "eac2801e89e53b985cd7852d39b58ddd15cdc7d2"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61b0f6e05071233780ced1a083ab744d13d05ab77c3444b6d1f210da23b9e21e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61b0f6e05071233780ced1a083ab744d13d05ab77c3444b6d1f210da23b9e21e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ccbf4c6476534e0158f27bb038a965f1d84b8bf2bddd040edef9726ab255d57"
    sha256 cellar: :any,                 x86_64_linux:  "2126fb9062adc060814e0f71d055b01147f31527f9ee9dd3a51cd361d858655c"
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
