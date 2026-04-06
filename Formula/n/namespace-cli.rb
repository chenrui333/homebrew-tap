class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.494",
      revision: "0e82a0568529bac1a19281040657021280763cdb"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf1258cf86541e3843cefc5c2a3ae95acecef25e79e800abc49c3a2d21d2a502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf1258cf86541e3843cefc5c2a3ae95acecef25e79e800abc49c3a2d21d2a502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf1258cf86541e3843cefc5c2a3ae95acecef25e79e800abc49c3a2d21d2a502"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa61b9919bf78ad301c49991b4b4d18c6895e82840a28725c022514f7b358b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e770dd86e64cf8af1c2d3aaabe9dcad0b72d5e8d802e9e9a89e3ea4136cb544"
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
