class HardcoverTui < Formula
  desc "Terminal UI client for Hardcover.app"
  homepage "https://github.com/NotMugil/hardcover-tui"
  url "https://github.com/NotMugil/hardcover-tui/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "3c42ef168b4cfe70f9c51726c2e2185156c9ee1e1b909dfcaee2dbcac218102d"
  license "AGPL-3.0-only"
  head "https://github.com/NotMugil/hardcover-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "348b5236e9b7a619a557a2dcc130b9cc4018dd593f7b459f46504f0c5fe1b5df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348b5236e9b7a619a557a2dcc130b9cc4018dd593f7b459f46504f0c5fe1b5df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de5c494f873673f65eff23b348c47b1c0f783398f31fd5e1a63d6dea5c32ee17"
    sha256 cellar: :any,                 x86_64_linux:  "44d7869b7a6f6629330591c5d99485fcc0e79255e27b0d344176d9f9a5e87f1a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/hardcover-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hardcover-tui --version")
    assert_match "Not authenticated", shell_output("#{bin}/hardcover-tui auth status")
  end
end
