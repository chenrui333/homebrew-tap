class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.474",
      revision: "a861d7d14f8a9846a069f2cbd7207b958a418322"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec84f7e2a6fdd4acef9dd0682ac9812044c782ee9e2cc1749b8d2f28f43bf31e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec84f7e2a6fdd4acef9dd0682ac9812044c782ee9e2cc1749b8d2f28f43bf31e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec84f7e2a6fdd4acef9dd0682ac9812044c782ee9e2cc1749b8d2f28f43bf31e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c013925d68af7262262c16f3dfb4f4794f4b3d4767728f67ed9d40b11369e7be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5938fdadc3b60a5b0705e858957eb400658d506e6857c34cc67b49f0ef21db38"
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
