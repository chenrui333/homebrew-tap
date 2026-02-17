class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.487",
      revision: "c45b135dfcd7124f7cac44febbf8f6d6e46239cc"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de5c6c6befcd0fcbb67213d6947b7277beda5ec84b3aea846b639f9b776d4ac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de5c6c6befcd0fcbb67213d6947b7277beda5ec84b3aea846b639f9b776d4ac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de5c6c6befcd0fcbb67213d6947b7277beda5ec84b3aea846b639f9b776d4ac2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d956f46ec201b0fc3a3752ffe46b49b2a1d639d0f2c2fc72f5c1ef289794e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec65adb03df29eba2d1a82db697f19c3ef71fa82b9eb18e5651500afd62f840"
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
