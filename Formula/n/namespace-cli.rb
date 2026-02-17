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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "250c50432bfb2a5cc0103c23d069e970643fdcc31e7d4285b3b4fdd0048202e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "250c50432bfb2a5cc0103c23d069e970643fdcc31e7d4285b3b4fdd0048202e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "250c50432bfb2a5cc0103c23d069e970643fdcc31e7d4285b3b4fdd0048202e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f45455dd527e317776aed1f3137f7eee53ead4c366e8136507bc003b4dbbcc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d6417c4720a9e6881666a280cf2828bfa9d83279159a05dfee22fe59181df4a"
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
