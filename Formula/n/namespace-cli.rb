class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.559",
      revision: "8f53ba50b40d09b7dbcc14bea6023f39391d1f91"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629f8934ff555c49827416dae223753a45a2d7b5d20e31925b8f76463033327e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "629f8934ff555c49827416dae223753a45a2d7b5d20e31925b8f76463033327e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "629f8934ff555c49827416dae223753a45a2d7b5d20e31925b8f76463033327e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0f39c3c0ebe5b001b64bdc615accdfe2bf1d4b4116515691f80830b2bd0899e"
    sha256 cellar: :any,                 x86_64_linux:  "ea3df2897e0e173e91b6588f6a3e7e515f7306a7ac57d5d32bcda1ac6c2d48f7"
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
