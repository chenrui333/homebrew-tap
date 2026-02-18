class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.489",
      revision: "7a8c205d71692f992d203c837075f13c5a221f57"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc42863038fb1db6765c469d9c17dc9e74eea60c24c44b1a9565d5d1130253c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc42863038fb1db6765c469d9c17dc9e74eea60c24c44b1a9565d5d1130253c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc42863038fb1db6765c469d9c17dc9e74eea60c24c44b1a9565d5d1130253c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32c337e3146f732c5509e83bdfee1654195575372c79d89fe8adc28a300a9944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b8e15daed70423d03538b7122f9e3a81318d57b820209981dd88b5aff0cd02"
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
