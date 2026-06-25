class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.529",
      revision: "2d1f8186b3822947eae59a5d518bd195276caa15"
  license "Apache-2.0"
  head "https://github.com/HarishChandran3304/better-env.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11689cefe2bef381171371be2f06a07c35f783dbb4bd6737f508b6648ee2be49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11689cefe2bef381171371be2f06a07c35f783dbb4bd6737f508b6648ee2be49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11689cefe2bef381171371be2f06a07c35f783dbb4bd6737f508b6648ee2be49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4d9d9db731bfc2a8f51bf9eb85a6bd5c4cbb2179dfb45343b12aa0d49e7a154"
    sha256 cellar: :any,                 x86_64_linux:  "d76ed7cefe0a0c63bc649fa99ea29c06b564e5e2e09bc850458a90114c6769de"
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
