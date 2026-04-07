class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.496",
      revision: "7d0579978e9dca4dd459e37cd001485d48260b7f"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68eea65d21402d7dcb7b1f3bd52502dbe9e3746b7bac627f949ed11703a1aa47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68eea65d21402d7dcb7b1f3bd52502dbe9e3746b7bac627f949ed11703a1aa47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68eea65d21402d7dcb7b1f3bd52502dbe9e3746b7bac627f949ed11703a1aa47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39914f6845d9dc45c440704f54836ee5fe3c9721f60c09fbc2f60b8631dba5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39cef6a277a65f083c35947fb07348d5b8da51229c6a9a836d215acc249f322b"
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
