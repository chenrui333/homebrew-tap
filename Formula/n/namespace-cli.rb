class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.509",
      revision: "b912354e53524fab8ae9599c093c708383124c07"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f1127ba13b930219c2355c1d2f8245f07eec460d4a6edc625408dc6d52026b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d9fb931ade39eecdd9dd8b6c69cc25b3b3dacdf0b0c657242cad2d36bb0b8e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65209263f09eec47db49ce68083f9ffde3735b0ccbd7a05c1ce41a4af6c50063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5492a512eb5fffce0b6ad587478ff1073f53ac4554718584c4a80662d9c0a83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a43bcdf68b2a2d18f328129600998c927fb13d552b2c1869b460fe0b2365132"
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
