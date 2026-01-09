class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.470",
      revision: "f7dbe7f43b08cb0fc6342b5fc296f0701980a6a3"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1a72d04ef28965bba25250b3de62ad3f1853ac58f753fdffcb9196dd9495ffa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1a72d04ef28965bba25250b3de62ad3f1853ac58f753fdffcb9196dd9495ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1a72d04ef28965bba25250b3de62ad3f1853ac58f753fdffcb9196dd9495ffa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "201e7c7f2dd45c5749a1279985241d28cb2df99c89e58d3e24339bcbbc337e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1060d4729cd58efce58f1c70ba6efb6af66dac2b627655d8782f7140635cf75"
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
