class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.505",
      revision: "284b70c0d0cec2486f4833aab13d6e755067fe9f"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72c83f370e2fd2150f0509d3c984c04620a8d503238556e9cb2a59ffae5aa078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72c83f370e2fd2150f0509d3c984c04620a8d503238556e9cb2a59ffae5aa078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72c83f370e2fd2150f0509d3c984c04620a8d503238556e9cb2a59ffae5aa078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "508d41188cba28a23fcd99752c72b7048daa0f79df3f0a02adc29254b65d2668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fe0a2d7a3afb36454b2d6c4ae759996b37c0650a3aef63f45e84a2ba4faaf64"
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
