class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.473",
      revision: "7a21b61b629d7537862cc791a6495aa7d9808c25"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c5d9e26f574e038067238ffe5ecaa5d108eea363b433ac44182c15e0ca83ae9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c5d9e26f574e038067238ffe5ecaa5d108eea363b433ac44182c15e0ca83ae9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c5d9e26f574e038067238ffe5ecaa5d108eea363b433ac44182c15e0ca83ae9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdf609ed43deee4d676661ad5b881dcf84ac80119f820d5d585fd4d4515458c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c70c73b791e93d7ca9b9a267c343cf842bd696bc11e3af1a59601282bffbd59e"
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
