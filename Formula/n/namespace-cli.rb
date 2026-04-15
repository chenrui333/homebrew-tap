class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.501",
      revision: "1047e431ce9bf6c9f1b3c3b109bb1c58643de158"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a6fcfa7e985e3c6c3a624cf62c0a5fd390d8f6ae88d680d4f8d2d68a0ae8062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a6fcfa7e985e3c6c3a624cf62c0a5fd390d8f6ae88d680d4f8d2d68a0ae8062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a6fcfa7e985e3c6c3a624cf62c0a5fd390d8f6ae88d680d4f8d2d68a0ae8062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70553e6e505836891e0f19d46ba399451977419345df04b4c817fdda9271a144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adcac6a1420690b7d7b459973f5e7c9cecaa1c21e9156e6f8bbb80f1151bbbc1"
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
